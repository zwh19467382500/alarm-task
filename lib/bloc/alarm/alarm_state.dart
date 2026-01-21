import 'package:equatable/equatable.dart';
import 'package:simple_alarm/entities/alarm_task.dart';

abstract class AlarmState extends Equatable {
  const AlarmState();

  @override
  List<Object> get props => [];
}

/// 初始状态
class AlarmInitial extends AlarmState {}

/// 加载状态 - 用于加载列表或处理单个操作
class AlarmInProgress extends AlarmState {}

/// 加载闹钟任务列表成功
class AlarmsLoadSuccess extends AlarmState {
  final List<AlarmTask> tasks;

  const AlarmsLoadSuccess(this.tasks);

  @override
  List<Object> get props => [tasks];
}

/// 加载闹钟任务列表失败
class AlarmsLoadFailure extends AlarmState {
  final String error;

  const AlarmsLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}

/// 单个操作（如保存、删除）成功
class AlarmActionSuccess extends AlarmState {
  final String message;

  const AlarmActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

/// 单个操作（如保存、删除）失败
class AlarmActionFailure extends AlarmState {
  final String error;

  const AlarmActionFailure(this.error);

  @override
  List<Object> get props => [error];
}

/// 状态：触发显示推送消息弹窗
class ShowPushMessagePopup extends AlarmState {
  final Map<String, dynamic> message;

  const ShowPushMessagePopup(this.message);

  @override
  List<Object> get props => [message];
}