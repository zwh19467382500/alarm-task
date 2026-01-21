import 'package:isar_community/isar.dart';
import 'package:simple_alarm/entities/app_settings.dart';
import 'package:simple_alarm/service/database_service.dart';

class SettingsRepository {
  late final Isar _isar;

  // 允许传入Isar实例，方便测试时模拟
  SettingsRepository({Isar? isar}) {
    _isar = isar ?? DatabaseService.isar;
  }

  /// 获取下一个可用的、唯一的闹钟ID
  Future<int> getNextAlarmId() async {
    try {
      // 在一个事务中完成"读-改-写"，保证操作的原子性
      return await _isar.writeTxn(() async {
        // 获取ID为0的设置对象，如果不存在则创建一个新的
        final settings = await _isar.appSettings.get(0) ?? AppSettings();

        // 将ID加一
        settings.lastUsedAlarmId++;

        // 将新的ID值存回数据库
        await _isar.appSettings.put(settings);

        // 返回这个新的、独一无二的ID
        return settings.lastUsedAlarmId;
      });
    } catch (e) {
      print("获取下一个闹钟ID失败: $e");
      rethrow;
    }
  }
}
