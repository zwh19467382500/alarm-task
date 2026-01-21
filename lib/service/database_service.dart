import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_alarm/entities/alarm_task.dart';
import 'package:simple_alarm/entities/app_settings.dart';
import 'package:simple_alarm/entities/time_node_regist.dart';

class DatabaseService {
  static Isar? _isar;

  // 提供对isar实例的安全访问
  static Isar get isar {
    if (_isar == null) {
      throw Exception('数据库未初始化');
    }
    return _isar!;
  }

  DatabaseService._();

  static Future<void> initialize() async {
    // 检查Isar实例是否已经存在并且是打开的，如果已打开，则直接返回。
    if (_isar != null && _isar!.isOpen) {
      print("数据库已经初始化，跳过重复操作。");
      return;
    }

    try {
      print("数据库未初始化，正在执行初始化...");
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [
          AlarmTaskSchema,
          TimeNodeRegistSchema,
          AppSettingsSchema,
        ],
        directory: dir.path,
      );
    } catch (e) {
      print("数据库初始化失败: $e");
      rethrow;
    }
  }
}
