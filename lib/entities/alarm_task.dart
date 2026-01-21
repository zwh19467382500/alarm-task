import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'time_node_regist.dart';  // 保留导入

part 'alarm_task.g.dart';

@collection
@JsonSerializable(explicitToJson: true)
class AlarmTask {
  Id id = Isar.autoIncrement;

  String? title; // 标题
  String? type; // 闹钟类型: WakeUp, ClassBell, DrinkWater
  bool isActive; // 闹钟状态，true开启 / false关闭

  int? timeInterval; // 统一时间间隔(分钟)
  bool snoozeEnabled; // 是否允许稍后提醒
  bool soundEnabled; // 是否响铃

  String? scheduleType; // 循环周期类型: Once, Daily, Workday, Weekend, Custom
  List<int> weekDays; // [1, 2, 3, 4, 5, 6, 7]

  String? startTime; // 劝喝水开始时间 (HH:mm)
  String? endTime; // 劝喝水结束时间 (HH:mm)
  List<int> relativeTimes; // 存储相对时间间隔的数组

  // 移除原来的timeNodes，添加新的关联
  @Backlink(to: 'alarmTask')
  @JsonKey(includeFromJson: false, includeToJson: false)
  final timeNodeRegists = IsarLinks<TimeNodeRegist>();  // 保留

  AlarmTask({
    this.title,
    this.type,
    this.isActive = true,
    this.timeInterval,
    this.snoozeEnabled = false,
    this.soundEnabled = true,
    this.scheduleType,
    required this.weekDays,
    this.startTime,
    this.endTime,
    required this.relativeTimes,  // 新增
  });

  factory AlarmTask.fromJson(Map<String, dynamic> json) => _$AlarmTaskFromJson(json);
  Map<String, dynamic> toJson() => _$AlarmTaskToJson(this);
}
