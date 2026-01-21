import 'package:simple_alarm/service/alarm_scheduling_utils.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:simple_alarm/repository/alarm_repository.dart';
import 'package:simple_alarm/service/database_service.dart';

/// 顶层函数，专门用于处理后台闹钟事件。
/// 这是一个独立的入口点，当应用被唤醒时由 `alarm` 插件调用。
Future<void> handleAlarmRinging(dynamic alarmSet) async {
  // 使用 dynamic 类型，并手动访问 .alarms 属性，参考了你的原始代码，这更可靠
  final alarms = alarmSet.alarms;
  if (alarms == null || alarms.isEmpty) {
    print('[Background] 收到闹钟事件，但没有找到有效的闹钟列表。');
    return;
  }

  print('[Background] 闹钟事件流收到数据，包含 ${alarms.length} 个闹钟需要处理。');

  // 遍历所有在同一时间响铃的闹钟
  for (final alarmSettings in alarms) {
    print('[Background] 正在处理闹钟: ID=${alarmSettings.id}, 时间=${DateTime.now()}');

    // 1. 初始化必要的服务（使其幂等，防止冲突）
    final notificationsPlugin = await _initializeServicesForBackground();

    // 2. 创建依赖的 Repository
    final alarmRepository = AlarmRepository();

    try {
      final alarmId = alarmSettings.id;

      // 根据alarmSystemId查找TimeNodeRegist，并加载其关联的AlarmTask
      final regist = await alarmRepository.getTimeNodeRegistByAlarmSystemId(
        alarmId,
      );
      if (regist != null && regist.alarmTask.value != null) {
        // *** 修正逻辑顺序：立即设置30秒后自动停止的定时器 ***
        Future.delayed(const Duration(seconds: 30), () async {
          if (await Alarm.isRinging(alarmId)) {
            print('[Background] 闹钟自动停止: ID=$alarmId');
            await Alarm.stop(alarmId);

            // *** 修正功能缺失：添加回自动停止后的通知 ***
            await notificationsPlugin.show(
              alarmId + 1000000, // 使用偏移ID避免和响铃通知冲突
              '闹钟已停止',
              '任务 \'${regist.alarmTask.value?.title ?? ''}\' 的闹钟已自动停止。', // Corrected escaping for single quotes within string
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'alarm_channel', // 必须和主程序中注册的channel_id一致
                  '闹钟提醒',
                  channelDescription: '闹钟相关的通知',
                  importance: Importance.max,
                  priority: Priority.high,
                ),
              ),
            );
          }
        });

        final task = regist.alarmTask.value!;
        print('[Background] 找到任务: ${task.title}');

        // 重新调度下一个闹钟（如果需要）
        await task.timeNodeRegists.load();
        final sortedRegists = task.timeNodeRegists.toList()
          ..sort((a, b) => a.exactDateTime.compareTo(b.exactDateTime));

        if (sortedRegists.isNotEmpty &&
            sortedRegists.last.alarmSystemId == alarmId) {
          print('[Background] 这是最后一个节点，调用静态方法重新调度...');

          //判断重复类型，如果是仅一次类型的，则关闭闹钟任务，否则触发闹钟任务更新
          if (task.scheduleType == "Once") {
            print('[Background] 仅一次任务，关闭闹钟任务...');
            // 调用静态方法关闭闹钟任务
            await AlarmSchedulingUtils.closeAlarmTask(task, alarmId);
          } else {
            // 将 task 实体转换为 DTO
            final taskDto = AlarmSchedulingUtils.convertTaskEntityToDto(task);
            // 安全地调用静态方法，该方法会进一步调用Service
            await AlarmSchedulingUtils.updateAlarmTask(taskDto, alarmId);
          }
        }
      } else {
        print('[Background] 未找到对应的任务注册信息。');
      }
    } catch (e, stackTrace) {
      print('[Background] 处理闹钟回调时出错: $e');
      print('           错误堆栈: $stackTrace');
    }
  }
}

/// 为后台任务初始化所需的服务, 并返回通知插件实例
Future<FlutterLocalNotificationsPlugin>
_initializeServicesForBackground() async {
  // 初始化数据库 (必须是幂等的)
  await DatabaseService.initialize();

  // 初始化通知 (也应该是幂等的)
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  return flutterLocalNotificationsPlugin;
}
