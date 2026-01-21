import 'package:get_it/get_it.dart';
import 'package:simple_alarm/bloc/alarm/alarm_bloc.dart';
import 'package:simple_alarm/repository/alarm_repository.dart';
import 'package:simple_alarm/repository/settings_repository.dart';
import 'package:simple_alarm/service/alarm_service.dart';
import 'package:simple_alarm/service/jpush_util.dart';

import 'package:simple_alarm/bloc/auth/auth_bloc.dart';
import 'package:simple_alarm/service/auth/api_service.dart';
import 'package:simple_alarm/service/auth/storage_service.dart';
import 'package:simple_alarm/service/settings_service.dart';

// 创建 GetIt 的全局单例
final locator = GetIt.instance;

/// 配置服务定位器，注册所有需要全局访问的服务
void setupLocator() {
  // Storage & API Services
  locator.registerLazySingleton(() => StorageService());
  locator.registerLazySingleton(() => ApiService(locator<StorageService>()));
  locator.registerLazySingleton(() => SettingsService());
  locator.registerLazySingleton(() => JPushUtil());

  // BLoCs
  locator.registerLazySingleton<AuthBloc>(() => AuthBloc(
        storageService: locator<StorageService>(),
        apiService: locator<ApiService>(),
      ));
  // 使用“懒加载单例”模式注册你的服务。
  // 这意味着只有当第一次请求它们时，它们才会被创建。

  // Level 3: Repositories
  locator.registerLazySingleton(() => SettingsRepository());
  locator.registerLazySingleton(() => AlarmRepository());

  // Level 2: Services
  locator.registerLazySingleton(() => AlarmService(
        alarmRepository: locator<AlarmRepository>(),
      ));

  // Level 1: BLoCs (作为懒加载单例，确保只在第一次被UI使用时才创建)
  locator.registerLazySingleton<AlarmBloc>(() => AlarmBloc(
    alarmService: locator<AlarmService>(),
  ));

  print('服务定位器配置完成');
}
