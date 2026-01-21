import 'package:simple_alarm/bloc/alarm/alarm_bloc.dart';
import 'package:simple_alarm/bloc/alarm/alarm_event.dart';
import 'package:simple_alarm/dto/alarm_task_dto.dart';
import 'package:simple_alarm/entities/time_node_regist.dart';
import 'package:simple_alarm/entities/alarm_task.dart';
import 'package:simple_alarm/repository/alarm_repository.dart';
import 'package:simple_alarm/service/alarm_scheduling_utils.dart';
import 'package:simple_alarm/service_locator.dart';

/// 服务类，作为业务逻辑处理的核心，并统一负责UI通知。
class AlarmService {
  final AlarmRepository _alarmRepository;

  AlarmService({required AlarmRepository alarmRepository})
    : _alarmRepository = alarmRepository;

  /// 保存或更新闹钟任务，由UI层调用
  Future<void> saveAlarm(AlarmTaskDto dto) async {
    await _recalculateAndSaveTask(dto, null);
    locator<AlarmBloc>().add(AlarmsRefreshed());
  }

  /// 从后台任务更新闹钟，由后台回调调用
  Future<void> recalculateAndSaveTask(
    AlarmTaskDto dto,
    int? alarmingNodeId,
  ) async {
    await _recalculateAndSaveTask(dto, alarmingNodeId);
    // 这里的通知由 saveAlarm 方法的调用者（即后台任务）负责，以保持逻辑分离
    // 或者，如果希望总是通知，也可以在这里添加
    locator<AlarmBloc>().add(AlarmsRefreshed());
  }

  /// 关闭闹钟任务的独立方法
  Future<void> closeAlarmTask(AlarmTask task, int? alarmId) async {
    // 取消系统中的节点注册
    await AlarmSchedulingUtils.cancelNodesInSystem(
      task.timeNodeRegists.toList(),
      alarmId,
    );

    // 删除注册节点
    await _alarmRepository.deleteRegistNodes(task.id);

    // 更新任务状态
    task.isActive = false;
    await _alarmRepository.updateTask(task);

    // 刷新Bloc状态
    locator<AlarmBloc>().add(AlarmsRefreshed());
  }

  /// 切换闹钟任务的激活状态
  Future<void> toggleAlarmStatus(int taskId) async {
    final task = await _alarmRepository.getTaskWithNodes(taskId);
    if (task == null) return;

    if (task.isActive) {
      // --- Deactivate Logic ---
      await closeAlarmTask(task, null);
    } else {
      // --- Activate Logic ---
      task.isActive = true;
      final taskDto = AlarmSchedulingUtils.convertTaskEntityToDto(task);
      await _recalculateAndSaveTask(taskDto, null);
      locator<AlarmBloc>().add(AlarmsRefreshed());
    }
  }

  /// 删除一个闹钟任务
  Future<void> deleteAlarm(int taskId) async {
    final task = await _alarmRepository.getTaskWithNodes(taskId);
    if (task == null) return;
    await AlarmSchedulingUtils.cancelNodesInSystem(
      task.timeNodeRegists.toList(),
      null,
    );
    await _alarmRepository.deleteTaskAndNodes(taskId);
    locator<AlarmBloc>().add(AlarmsRefreshed());
  }

  /// 核心私有方法：重新计算并保存任务
  Future<void> _recalculateAndSaveTask(
    AlarmTaskDto dto,
    int? alarmingNodeId,
  ) async {
    if (dto.id != null) {
      final existingTask = await _alarmRepository.getTaskWithNodes(dto.id!);
      if (existingTask != null) {
        await AlarmSchedulingUtils.cancelNodesInSystem(
          existingTask.timeNodeRegists.toList(),
          alarmingNodeId,
        );
        await _alarmRepository.deleteRegistNodes(dto.id!);
      }
    }

    final calculatedNodes = await AlarmSchedulingUtils.calculateTimeNodes(
      dto,
      false,
    );
    if (calculatedNodes.isEmpty) {
      // 如果没有计算出节点，对于更新操作，意味着任务结束，需要更新状态
      if (dto.id != null) {
        final taskToDeactivate = await _alarmRepository.getTaskWithNodes(
          dto.id!,
        );
        if (taskToDeactivate != null) {
          taskToDeactivate.isActive = false;
          await _alarmRepository.updateTask(taskToDeactivate);
        }
      }
      return;
    }

    final taskToSave = AlarmTask(
      title: dto.title,
      type: dto.type,
      isActive: true,
      timeInterval: dto.timeInterval,
      snoozeEnabled: dto.type == 'WakeUp',
      soundEnabled: dto.soundEnabled,
      scheduleType: dto.scheduleType,
      weekDays: dto.weekDays,
      startTime: dto.startTime,
      endTime: dto.endTime,
      relativeTimes: dto.relativeTimes,
    );
    if (dto.id != null) {
      taskToSave.id = dto.id!;
    }

    final registsToSave = <TimeNodeRegist>[];
    for (int i = 0; i < calculatedNodes.length; i++) {
      final info = calculatedNodes[i];
      final regist = TimeNodeRegist(
        alarmSystemId: info.alarmSystemId,
        sort: info.sort,
        isHead: info.isHead,
        exactDateTime: info.exactDateTime,
      );
      registsToSave.add(regist);
    }

    await _alarmRepository.saveTask(taskToSave, registsToSave);
    await AlarmSchedulingUtils.registerNodesWithSystem(
      calculatedNodes,
      taskToSave,
    );
  }

  // --- Read-only methods ---

  Future<List<AlarmTask>> getTasks() async {
    return _alarmRepository.getAllTasksWithNodes();
  }

  Future<Duration?> calculateCountdown(int taskId) async {
    final task = await _alarmRepository.getTaskWithNodes(taskId);
    if (task == null || !task.isActive || task.timeNodeRegists.isEmpty) {
      return null;
    }

    final now = DateTime.now();
    final sortedRegists = task.timeNodeRegists.toList()
      ..sort((a, b) => a.exactDateTime.compareTo(b.exactDateTime));

    for (final regist in sortedRegists) {
      if (regist.exactDateTime.isAfter(now)) {
        return regist.exactDateTime.difference(now);
      }
    }
    return null;
  }

  
}
