import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:simple_alarm/access/ui/pages/decision_page.dart';
import 'package:simple_alarm/bloc/alarm/alarm_bloc.dart';
import 'package:simple_alarm/bloc/alarm/alarm_event.dart';
import 'package:simple_alarm/service/database_service.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:simple_alarm/service/alarm_handler.dart';
import 'package:simple_alarm/service/settings_service.dart';
import 'package:simple_alarm/service_locator.dart';
import 'package:simple_alarm/service/jpush_util.dart';

import 'package:simple_alarm/bloc/auth/auth_bloc.dart';
import 'package:simple_alarm/bloc/auth/auth_event.dart';

// 添加全局的通知插件实例
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  setupLocator(); // 配置服务定位器
  await locator<SettingsService>().init(); // 初始化设置服务

  // 初始化数据库 (确保它是幂等的)
  try {
    await DatabaseService.initialize();
  } catch (e) {
    print("数据库初始化失败: $e");
  }

  // 初始化闹钟服务，这是后台唤醒的关键
  try {
    await Alarm.init();
    print("闹钟服务初始化成功");
  } catch (e) {
    print("闹钟服务初始化失败: $e");
  }

  // 监听闹钟事件流
  Alarm.ringing.listen(handleAlarmRinging);

  // 初始化通知插件
  try {
    await _initializeNotifications();
  } catch (e) {
    print("通知插件初始化失败: $e");
  }

  // 请求必要权限
  try {
    await Permission.notification.request();
    await Permission.scheduleExactAlarm.request();
    await Permission.ignoreBatteryOptimizations.request();
    await Permission.systemAlertWindow.request();
  } catch (e) {
    print("权限请求失败: $e");
  }

  runApp(const MyApp());
}

// 添加通知插件初始化函数
Future<void> _initializeNotifications() async {
  // Android通知设置
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // iOS通知设置
  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // 创建Android通知渠道
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'alarm_channel', // Channel ID
    '闹钟提醒', // Channel name
    description: '闹钟相关的通知', // Channel description
    importance: Importance.max,
  );

  // 创建通知渠道
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final jPushUtil = locator<JPushUtil>();

  @override
  void initState() {
    super.initState();
    // 初始化极光推送
    WidgetsBinding.instance.addPostFrameCallback((_) {
      jPushUtil.initPlatformState(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => locator<AuthBloc>()..add(AppStarted()),
        ),
        BlocProvider<AlarmBloc>(
          create: (context) => locator<AlarmBloc>()..add(AlarmsLoaded()),
        ),
      ],
      child: MaterialApp(title: '简单闹钟', home: const DecisionPage()),
    );
  }
}
