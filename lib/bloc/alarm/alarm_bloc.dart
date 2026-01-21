import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_alarm/bloc/alarm/alarm_event.dart';
import 'package:simple_alarm/bloc/alarm/alarm_state.dart';
import 'package:simple_alarm/service/alarm_service.dart';
import 'package:simple_alarm/service/jpush_util.dart';
import 'package:simple_alarm/service_locator.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  final AlarmService _alarmService;
  late final StreamSubscription<Map<String, dynamic>> _jpushSubscription;

  AlarmBloc({required AlarmService alarmService})
      : _alarmService = alarmService,
        super(AlarmInitial()) {

    // 从服务定位器获取JPushUtil实例并监听其流
    final jpushUtil = locator<JPushUtil>();
    _jpushSubscription = jpushUtil.messageStream.listen((message) {
      add(PushMessageReceived(message));
    });

    on<AlarmsLoaded>(_onAlarmsLoaded);
    on<AlarmsRefreshed>(_onAlarmsRefreshed); // 添加新事件的处理器
    on<AlarmSaved>(_onAlarmSaved);
    on<AlarmDeleted>(_onAlarmDeleted);
    on<AlarmStatusToggled>(_onAlarmStatusToggled);
    on<PushMessageReceived>(_onPushMessageReceived); // 添加推送事件的处理器
  }

  @override
  Future<void> close() {
    _jpushSubscription.cancel(); // 在Bloc关闭时取消订阅
    return super.close();
  }

  Future<void> _onAlarmsLoaded(
      AlarmsLoaded event, Emitter<AlarmState> emit) async {
    emit(AlarmInProgress());
    try {
      final tasks = await _alarmService.getTasks();
      emit(AlarmsLoadSuccess(tasks));
    } catch (e) {
      emit(AlarmsLoadFailure(e.toString()));
    }
  }

  // 新增的刷新方法，逻辑与加载方法一致
  Future<void> _onAlarmsRefreshed(
      AlarmsRefreshed event, Emitter<AlarmState> emit) async {
    // 不发射 Loading 状态，以避免UI闪烁，实现静默刷新
    try {
      final tasks = await _alarmService.getTasks();
      emit(AlarmsLoadSuccess(tasks));
    } catch (e) {
      emit(AlarmsLoadFailure(e.toString()));
    }
  }

  Future<void> _onAlarmSaved(
      AlarmSaved event, Emitter<AlarmState> emit) async {
    emit(AlarmInProgress());
    try {
      await _alarmService.saveAlarm(event.dto);
      emit(const AlarmActionSuccess('闹钟已保存'));
    } catch (e) {
      emit(AlarmActionFailure('保存失败: ${e.toString()}'));
    }
    // 刷新操作已移至AlarmService，此处不再需要
    // add(AlarmsLoaded());
  }

  Future<void> _onAlarmDeleted(
      AlarmDeleted event, Emitter<AlarmState> emit) async {
    emit(AlarmInProgress());
    try {
      await _alarmService.deleteAlarm(event.taskId);
      emit(const AlarmActionSuccess('闹钟已删除'));
    } catch (e) {
      emit(AlarmActionFailure('删除失败: ${e.toString()}'));
    }
    // 刷新操作已移至AlarmService，此处不再需要
    // add(AlarmsLoaded());
  }

  Future<void> _onAlarmStatusToggled(
      AlarmStatusToggled event, Emitter<AlarmState> emit) async {
    emit(AlarmInProgress());
    try {
      await _alarmService.toggleAlarmStatus(event.taskId);
      emit(const AlarmActionSuccess('状态已更新'));
    } catch (e) {
      emit(AlarmActionFailure('更新失败: ${e.toString()}'));
    }
    // 刷新操作已移至AlarmService，此处不再需要
    // add(AlarmsLoaded());
  }

  // 新增的推送消息处理器
  void _onPushMessageReceived(PushMessageReceived event, Emitter<AlarmState> emit) {
    emit(ShowPushMessagePopup(event.message));
  }
}
