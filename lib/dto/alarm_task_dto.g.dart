// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_task_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlarmTaskDto _$AlarmTaskDtoFromJson(Map<String, dynamic> json) => AlarmTaskDto(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String,
  type: json['type'] as String,
  soundEnabled: json['soundEnabled'] as bool,
  scheduleType: json['scheduleType'] as String,
  weekDays: (json['weekDays'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  relativeTimes: (json['relativeTimes'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  timeInterval: (json['timeInterval'] as num?)?.toInt(),
  startTime: json['startTime'] as String?,
  endTime: json['endTime'] as String?,
);

Map<String, dynamic> _$AlarmTaskDtoToJson(AlarmTaskDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'soundEnabled': instance.soundEnabled,
      'scheduleType': instance.scheduleType,
      'weekDays': instance.weekDays,
      'relativeTimes': instance.relativeTimes,
      'timeInterval': instance.timeInterval,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };
