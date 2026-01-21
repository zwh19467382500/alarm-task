import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:jpush_flutter/jpush_interface.dart';
import 'package:simple_alarm/dto/alarm_task_dto.dart';
import 'package:simple_alarm/service/alarm_service.dart';
import 'package:simple_alarm/service_locator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class JPushUtil {
  static final JPushUtil _instance = JPushUtil._internal();
  factory JPushUtil() => _instance;
  JPushUtil._internal();

  final JPushFlutterInterface jPush = JPush.newJPush();

  // 1. 创建一个可以被多方监听的广播StreamController
  final _messageStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  // 2. 提供一个公共的Stream，让外部可以监听
  Stream<Map<String, dynamic>> get messageStream =>
      _messageStreamController.stream;

  Future<void> initPlatformState(BuildContext context) async {
    try {
      // 添加事件处理器
      jPush.addEventHandler(
        // 接收通知
        onReceiveNotification: (Map<String, dynamic> message) async {
          debugPrint("接收到通知: $message");

          // 验证和过滤推送消息
          await _processPushMessage(message);

          _messageStreamController.add(message);
        },
        // 点击通知
        onOpenNotification: (Map<String, dynamic> message) async {
          debugPrint("点击通知: $message");

          // 验证和过滤推送消息
          await _processPushMessage(message);

          // 3. 把消息放入流中
          _messageStreamController.add(message);
          // 处理通知点击跳转
          _handleNotificationClick(context, message);
        },
        // 接收自定义消息
        onReceiveMessage: (Map<String, dynamic> message) async {
          debugPrint("接收到自定义消息: $message");

          // 验证和过滤推送消息
          await _processPushMessage(message);
        },
        // 通知授权状态
        onReceiveNotificationAuthorization: (message) async {
          debugPrint("通知授权状态: $message");
        },
        // 连接状态
        onConnected: (message) {
          debugPrint("极光推送连接成功: $message");
          return Future.value(null);
        },
      );

      // 初始化极光推送发送信息
      jPush.setup(
        appKey: dotenv.env['JPUSH_APP_KEY'] ?? '', // 极光推送AppKey
        channel: "developer-default",
        production: false, // 是否为生产环境
        debug: true, // 是否打印debug日志
      );

      // 获取Registration ID
      String? rid = await jPush.getRegistrationID();
      debugPrint("Registration ID: $rid");

      // 检查通知权限
      bool isEnabled = await jPush.isNotificationEnabled();
      debugPrint("通知权限状态: $isEnabled");

      if (!isEnabled) {
        // 引导用户开启通知权限
        _showPermissionDialog(context);
      }
    } catch (e) {
      debugPrint("极光推送初始化失败: $e");
    }
  }

  /// 处理推送消息，验证和过滤消息类型
  Future<void> _processPushMessage(Map<String, dynamic> message) async {
    final extras = message["extras"];
    if (extras != null && extras is Map<String, dynamic>) {
      final pushType = extras["type"]?.toString();

      // 检查是否为创建闹钟的推送消息
      if (pushType == "create_alarm") {
        await _handleCreateAlarmMessage(extras);
      }
    }
  }

  /// 处理创建闹钟的推送消息
  Future<void> _handleCreateAlarmMessage(Map<String, dynamic> extras) async {
    try {
      final alarmData = extras["data"];
      if (alarmData != null && alarmData is Map<String, dynamic>) {
        // 创建AlarmTaskDto对象
        final alarmTaskDto = AlarmTaskDto(
          title: alarmData["title"]?.toString() ?? "推送创建的闹钟",
          type: alarmData["type"]?.toString() ?? "WakeUp",
          soundEnabled: alarmData["soundEnabled"] ?? true,
          scheduleType: alarmData["scheduleType"]?.toString() ?? "Once",
          weekDays: List<int>.from(alarmData["weekDays"] ?? []),
          relativeTimes: List<int>.from(alarmData["relativeTimes"] ?? []),
          timeInterval: alarmData["timeInterval"],
          startTime: alarmData["startTime"]?.toString(),
          endTime: alarmData["endTime"]?.toString(),
        );

        // 调用闹钟服务创建闹钟
        await locator<AlarmService>().saveAlarm(alarmTaskDto);

        debugPrint("通过推送消息创建闹钟成功: ${alarmTaskDto.title}");
      } else {
        debugPrint("推送消息中缺少闹钟数据: $extras");
      }
    } catch (e) {
      debugPrint("处理创建闹钟推送消息失败: $e");
    }
  }

  // 处理通知点击
  void _handleNotificationClick(
    BuildContext context,
    Map<String, dynamic> message,
  ) {
    // 根据消息内容进行页面跳转
    String? extras = message["extras"];
    if (extras != null) {
      // 解析extras中的跳转信息
      debugPrint("通知点击 extras: $extras");
      // 例如：Navigator.push(context, MaterialPageRoute(builder: (context) => TargetPage()));
    }
  }

  // 显示权限引导对话框
  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("通知权限"),
        content: const Text("请开启通知权限以接收推送消息"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("取消"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              jPush.openSettingsForNotification();
            },
            child: const Text("去设置"),
          ),
        ],
      ),
    );
  }

  // 设置别名
  Future<void> setAlias(String alias) async {
    try {
      await jPush.setAlias(alias);
      debugPrint("设置别名成功: $alias");
    } catch (e) {
      debugPrint("设置别名失败: $e");
    }
  }

  // 删除别名
  Future<void> deleteAlias() async {
    try {
      await jPush.deleteAlias();
      debugPrint("删除别名成功");
    } catch (e) {
      debugPrint("删除别名失败: $e");
    }
  }

  // 设置标签
  Future<void> setTags(List<String> tags) async {
    try {
      await jPush.setTags(tags);
      debugPrint("设置标签成功: $tags");
    } catch (e) {
      debugPrint("设置标签失败: $e");
    }
  }

  // 清除所有通知
  Future<void> clearAllNotifications() async {
    try {
      await jPush.clearAllNotifications();
      debugPrint("清除所有通知成功");
    } catch (e) {
      debugPrint("清除所有通知失败: $e");
    }
  }
}
