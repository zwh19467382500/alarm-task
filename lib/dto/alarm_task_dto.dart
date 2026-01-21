import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alarm_task_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class AlarmTaskDto extends Equatable {
  final int? id; // 可选ID，用于区分是新建还是更新
  final String title;
  final String type;
  final bool soundEnabled;
  final String scheduleType;
  final List<int> weekDays;
  final List<int> relativeTimes;  // 新增：存储相对时间间隔的数组

  // 特定类型任务的属性
  final int? timeInterval; // for WakeUp, DrinkWater
  final String? startTime; // for DrinkWater, ClassBell, WakeUp
  final String? endTime; // for DrinkWater

  const AlarmTaskDto({
    this.id,
    required this.title,
    required this.type,
    required this.soundEnabled,
    required this.scheduleType,
    required this.weekDays,
    required this.relativeTimes,  // 修改参数名
    this.timeInterval,
    this.startTime,
    this.endTime,
  });

  factory AlarmTaskDto.fromJson(Map<String, dynamic> json) => _$AlarmTaskDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AlarmTaskDtoToJson(this);

  @override
  List<Object?> get props => [
        id,
        title,
        type,
        soundEnabled,
        scheduleType,
        weekDays,
        relativeTimes,  // 修改属性名
        timeInterval,
        startTime,
        endTime,
      ];
}
