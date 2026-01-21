import 'dart:convert';

import 'package:alarm/alarm.dart';
import 'package:intl/intl.dart';
import 'package:simple_alarm/dto/alarm_task_dto.dart';
import 'package:simple_alarm/entities/alarm_task.dart';
import 'package:simple_alarm/entities/time_node_regist.dart';
import 'package:simple_alarm/repository/settings_repository.dart';
import 'package:simple_alarm/service/alarm_service.dart';
import 'package:simple_alarm/service_locator.dart';

/// 一个独立的工具类，包含所有与闹钟计算、调度、更新相关的静态方法。
class AlarmSchedulingUtils {
  /// 根据alarmTaskDto更新闹钟任务（静态版本），作为后台任务的入口
  static Future<void> updateAlarmTask(
    AlarmTaskDto dto,
    int? alarmingNodeId,
  ) async {
    // 直接调用Service的方法，将所有复杂逻辑交给Service处理
    await locator<AlarmService>().recalculateAndSaveTask(dto, alarmingNodeId);
  }

  /// 静态方法，用于关闭闹钟任务，供后台任务调用
  static Future<void> closeAlarmTask(
    AlarmTask task,
    int? alarmingNodeId,
  ) async {
    // 通过服务定位器获取AlarmService实例并调用关闭方法
    await locator<AlarmService>().closeAlarmTask(task, alarmingNodeId);
  }

  /// DTO转换器 (静态版本)
  static AlarmTaskDto convertTaskEntityToDto(AlarmTask task) {
    return AlarmTaskDto(
      id: task.id,
      title: task.title ?? '',
      type: task.type ?? '',
      soundEnabled: task.soundEnabled,
      scheduleType: task.scheduleType ?? '',
      weekDays: task.weekDays,
      timeInterval: task.timeInterval,
      startTime: task.startTime,
      endTime: task.endTime,
      relativeTimes: task.relativeTimes,
    );
  }

  // --- Private Static Methods ---

  static Future<List<_CalculatedNodeInfo>> calculateTimeNodes(
    AlarmTaskDto dto,
    bool forceToNextActiveDay, {
    bool forceNextWeek = false,
  }) async {
    //todo 获取闹钟的重复类型，并根据重复类型获取生效日期
    int targetWeekday = -1;
    if (dto.scheduleType == 'Once') {
      //判断开始时间与当前时间
      final now = DateTime.now();
      final format = DateFormat("HH:mm");
      final startTime = format.parse(dto.startTime!);
      final alarmTimeToday = DateTime(
        now.year,
        now.month,
        now.day,
        startTime.hour,
        startTime.minute,
      );
      if (now.isBefore(alarmTimeToday)) {
        targetWeekday = _getCurrentWeekday();
      } else {
        targetWeekday = _getNextWeekday();
      }
    } else {
      final currentWeekday = _getCurrentWeekday();
      final scheduleInfo = _getOverlayAndNextActiveWeekday(
        currentWeekday,
        dto.weekDays,
      );
      if (scheduleInfo['nextActiveDay'] == -1) {
        return [];
      }

      targetWeekday = scheduleInfo['nextActiveDay']; //默认生效目标日为除当日之外的下一个生效日

      if (scheduleInfo['isOverlap']) {
        //包含今天
        if (dto.type != 'WakeUp') {
          targetWeekday =
              currentWeekday; //不是起床闹钟，则从当天开始计算，注册行为有其他方法控制，此处仅关注需要注册的时间节点。
          if (forceToNextActiveDay) {
            //强制计算下一个生效日
            targetWeekday = scheduleInfo['nextActiveDay'];
          }
        } else {
          //其他类型比较时间来确定
          final now = DateTime.now();
          // 解析 startTime 作为第一个时间节点
          final format = DateFormat("HH:mm");
          final startTime = format.parse(dto.startTime!);
          final alarmTimeToday = DateTime(
            now.year,
            now.month,
            now.day,
            startTime.hour,
            startTime.minute,
          );
          if (now.isBefore(alarmTimeToday)) {
            //创建时候，头结点的时间在当前时间之后，即没有过期，则当前日为生效日
            targetWeekday = currentWeekday;
          }
        }
      }
    }

    final startDateStr = _getClosestDateByWeekday(
      targetWeekday,
      forceNextWeek: forceNextWeek,
    );
    final startTimeStr = dto.startTime ?? '00:00';

    List<int> intervalsInMinutes = [];
    switch (dto.type) {
      case 'WakeUp':
        if (dto.timeInterval != null && dto.timeInterval! > 0) {
          intervalsInMinutes = List.filled(6, dto.timeInterval!);
        }
        break;
      case 'ClassBell':
        // 使用 relativeTimes 数组计算上课铃时间点
        intervalsInMinutes = dto.relativeTimes;
        break;
      case 'DrinkWater':
        final format = DateFormat("HH:mm");
        final startTime = format.parse(dto.startTime!);
        final endTime = format.parse(dto.endTime!);
        final interval = dto.timeInterval ?? 60;
        int diffMinutes = endTime.difference(startTime).inMinutes;
        if (endTime.isBefore(startTime)) {
          diffMinutes += 24 * 60;
        }
        final int intervalCount = (diffMinutes / interval).floor();
        if (intervalCount > 0) {
          intervalsInMinutes = List.filled(intervalCount, interval);
        }
        break;
      default:
        throw Exception("不支持的闹钟任务类型: ${dto.type}");
    }

    final dateTimeList = await _generateDateTimeList(
      startDateStr,
      startTimeStr,
      intervalsInMinutes,
    );
    //如果列表返回为空，则说明计算的时间节点均已超过当前时间，则重新计算为下一个生效日
    if (dateTimeList.isEmpty) {
      // 重新计算为下一个生效日，并强制使用下周的日期
      return await calculateTimeNodes(dto, true, forceNextWeek: true);
    }
    return dateTimeList;
  }

  static Future<void> registerNodesWithSystem(
    List<_CalculatedNodeInfo> calculatedNodes,
    AlarmTask task,
  ) async {
    print("进入闹钟注册循环，共${calculatedNodes.length}个时间节点");
    for (int i = 0; i < calculatedNodes.length; i++) {
      final nodeInfo = calculatedNodes[i];
      //与当前日期时间进行比较，不注册之前的
      if (nodeInfo.exactDateTime.isBefore(DateTime.now())) {
        continue;
      }

      String alarmType = '闹钟提醒';
      String alarmBody = '第$i个$alarmType';
      if (task.type == 'DrinkWater') {
        alarmType = '喝水提醒';
      } else if (task.type == 'ClassBell') {
        alarmType = '上课铃声';
      } else if (task.type == 'WakeUp') {
        alarmType = '起床闹钟';
        if (i == 0) {
          alarmBody = '该起床啦！';
        } else {
          alarmBody = '第$i个$alarmType稍后提醒';
        }
      }
      final alarmSettings = AlarmSettings(
        id: nodeInfo.alarmSystemId,
        dateTime: nodeInfo.exactDateTime,
        assetAudioPath: task.soundEnabled
            ? 'assets/alarm.mp3'
            : 'assets/silent100.mp3',
        loopAudio: task.soundEnabled,
        vibrate: true,
        allowAlarmOverlap: true,
        notificationSettings: NotificationSettings(
          title: '$alarmType-${task.title ?? '无标题'}',
          body: alarmBody,
          stopButton: '停止【$alarmType】',
        ),
        volumeSettings: VolumeSettings.fade(
          volume: task.soundEnabled ? null : 0,
          fadeDuration: Duration(seconds: 3),
        ),
      );
      print("注册闹钟参数===${JsonEncoder().convert(alarmSettings.toJson())}");
      final success = await Alarm.set(alarmSettings: alarmSettings);

      if (success) {
        print('系统闹钟设定成功: ${alarmSettings.dateTime.toString()}');
      } else {
        print('系统闹钟设定失败');
      }
    }
    print("闹钟注册循环完成");
  }

  static Future<void> cancelNodesInSystem(
    List<TimeNodeRegist> nodes,
    int? alarmingNodeId,
  ) async {
    for (final node in nodes) {
      if (alarmingNodeId != null && node.alarmSystemId == alarmingNodeId) {
        continue; //跳过当前响铃节点
      }
      await Alarm.stop(node.alarmSystemId);
      print('闹钟已取消: ID=${node.alarmSystemId}');
    }
  }

  static Future<List<_CalculatedNodeInfo>> _generateDateTimeList(
    String startDateStr,
    String startTimeStr,
    List<int> intervalsInMinutes,
  ) async {
    final settingsRepository = locator<SettingsRepository>();
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    DateTime currentDateTime = dateFormat.parse('$startDateStr $startTimeStr');

    //添加第一个节点
    final result = <_CalculatedNodeInfo>[];
    result.add(
      _CalculatedNodeInfo(
        alarmSystemId: await settingsRepository.getNextAlarmId(),
        exactDateTime: currentDateTime,
        sort: 0,
        relativeTime: 0,
        isHead: true,
        hour: currentDateTime.hour,
        minute: currentDateTime.minute,
      ),
    );
    //根据时间间隔计算添加剩余的节点
    for (int i = 0; i < intervalsInMinutes.length; i++) {
      currentDateTime = currentDateTime.add(
        Duration(minutes: intervalsInMinutes[i]),
      );
      result.add(
        _CalculatedNodeInfo(
          alarmSystemId: await settingsRepository.getNextAlarmId(),
          exactDateTime: currentDateTime,
          sort: i + 1,
          relativeTime: intervalsInMinutes[i],
          isHead: false,
          hour: currentDateTime.hour,
          minute: currentDateTime.minute,
        ),
      );
    }

    if (result.last.exactDateTime.isBefore(DateTime.now())) {
      // 如果最后一个时间节点已经过期，则返回空列表
      return [];
    }
    return result;
  }

  static int _getCurrentWeekday() => DateTime.now().weekday;

  static int _getNextWeekday() {
    final currentWeekday = DateTime.now().weekday;
    return currentWeekday == 7 ? 1 : currentWeekday + 1;
  }

  static Map<String, dynamic> _getOverlayAndNextActiveWeekday(
    int currentWeekday,
    List<int> activeDays,
  ) {
    if (activeDays.isEmpty) {
      return {'isOverlap': false, 'nextActiveDay': -1};
    }

    final activeWeekdayNumbers = activeDays..sort();

    bool isOverlap = activeWeekdayNumbers.contains(currentWeekday);
    int? nextActiveDay;
    for (final day in activeWeekdayNumbers) {
      if (day > currentWeekday) {
        nextActiveDay = day;
        break;
      }
    }
    nextActiveDay ??= activeWeekdayNumbers.first;
    return {'isOverlap': isOverlap, 'nextActiveDay': nextActiveDay};
  }

  static String _getClosestDateByWeekday(
    int targetWeekday, {
    bool forceNextWeek = false,
  }) {
    if (targetWeekday < 1 || targetWeekday > 7) {
      throw ArgumentError("星期参数必须在1-7之间");
    }
    DateTime today = DateTime.now();
    int currentWeekday = today.weekday;
    int daysToAdd = targetWeekday >= currentWeekday
        ? targetWeekday - currentWeekday
        : 7 - currentWeekday + targetWeekday;

    // 如果需要强制下周，且目标日是今天（daysToAdd == 0），则加7天
    if (forceNextWeek && daysToAdd == 0) {
      daysToAdd = 7;
    }

    return DateFormat(
      'yyyy-MM-dd',
    ).format(today.add(Duration(days: daysToAdd)));
  }
}

// 定义一个临时的内部类，用于在计算过程中携带完整信息
class _CalculatedNodeInfo {
  final int alarmSystemId;
  final DateTime exactDateTime;
  final int sort;
  final int relativeTime;
  final bool isHead;
  final int hour;
  final int minute;

  _CalculatedNodeInfo({
    required this.alarmSystemId,
    required this.exactDateTime,
    required this.sort,
    required this.relativeTime,
    required this.isHead,
    required this.hour,
    required this.minute,
  });
}
