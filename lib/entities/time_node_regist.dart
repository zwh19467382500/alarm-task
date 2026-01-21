import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'alarm_task.dart';

part 'time_node_regist.g.dart';

@collection
@JsonSerializable()
class TimeNodeRegist {
  Id id = Isar.autoIncrement;

  @Index()
  int alarmSystemId; // 用于注册到系统闹钟的、我们自己生成的唯一ID

  // 注册数据属性 (移除了relativeTime和hour/minute)
  int sort; // 在单个闹钟任务的时间序列中的排序
  bool isHead; // 是否为头节点
  DateTime exactDateTime; // 实际注册时间
  
  @JsonKey(includeFromJson: false, includeToJson: false)
  final alarmTask = IsarLink<AlarmTask>();

  TimeNodeRegist({
    this.alarmSystemId = 0,
    required this.sort,
    required this.isHead,
    required this.exactDateTime,
  });

  factory TimeNodeRegist.fromJson(Map<String, dynamic> json) => _$TimeNodeRegistFromJson(json);
  Map<String, dynamic> toJson() => _$TimeNodeRegistToJson(this);
}