import 'package:equatable/equatable.dart';
import 'package:simple_alarm/dto/alarm_task_dto.dart';

abstract class AlarmEvent extends Equatable {
  const AlarmEvent();

  @override
  List<Object> get props => [];
}

/// 事件：加载所有闹钟任务
class AlarmsLoaded extends AlarmEvent {}

/// 事件：从后台或任何地方强制刷新闹钟任务列表
class AlarmsRefreshed extends AlarmEvent {}

/// 事件：保存（新建或更新）一个闹钟任务
class AlarmSaved extends AlarmEvent {
  final AlarmTaskDto dto;

  const AlarmSaved(this.dto);

  @override
  List<Object> get props => [dto];
}

/// 事件：删除一个闹钟任务
class AlarmDeleted extends AlarmEvent {
  final int taskId;

  const AlarmDeleted(this.taskId);

  @override
  List<Object> get props => [taskId];
}

/// 事件：切换一个闹钟任务的激活状态
class AlarmStatusToggled extends AlarmEvent {
  final int taskId;

  const AlarmStatusToggled(this.taskId);

  @override
  List<Object> get props => [taskId];
}

/// 事件：接收到推送消息
class PushMessageReceived extends AlarmEvent {
  final Map<String, dynamic> message;

  const PushMessageReceived(this.message);

  @override
  List<Object> get props => [message];
}