import 'package:isar_community/isar.dart';

part 'app_settings.g.dart';

@collection
class AppSettings {
  Id id = 0; // 固定ID为0，因为我们全局只需要一个设置对象

  int lastUsedAlarmId;

  AppSettings({this.lastUsedAlarmId = 0});
}
