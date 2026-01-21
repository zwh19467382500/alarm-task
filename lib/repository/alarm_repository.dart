import 'package:isar_community/isar.dart';
import 'package:simple_alarm/entities/alarm_task.dart';
import 'package:simple_alarm/entities/time_node_regist.dart';
import 'package:simple_alarm/service/database_service.dart';

class AlarmRepository {
  late final Isar _isar;

  AlarmRepository({Isar? isar}) {
    _isar = isar ?? DatabaseService.isar;
  }

  /// 保存一个闹钟任务及其所有注册数据
  Future<void> saveTask(AlarmTask task, List<TimeNodeRegist> registNodes) async {
    try {
      await _isar.writeTxn(() async {
        // 将任务存入数据库
        await _isar.alarmTasks.put(task);
        
        // 将所有注册节点存入数据库
        await _isar.timeNodeRegists.putAll(registNodes);

        // 建立从任务到注册节点的链接
        task.timeNodeRegists.addAll(registNodes);
        await task.timeNodeRegists.save();
        
        // 建立从每个注册节点回到任务的链接
        for (var node in registNodes) {
          node.alarmTask.value = task;
          await node.alarmTask.save();
        }
      });
      print("保存闹钟任务到数据库完成");
    } catch (e) {
      print("保存闹钟任务到数据库失败: $e");
      rethrow;
    }
  }

  /// 获取所有闹钟任务
  Future<List<AlarmTask>> getAllTasks() async {
    try {
      return await _isar.alarmTasks.where().findAll();
    } catch (e) {
      print("获取所有闹钟任务失败: $e");
      rethrow;
    }
  }

  /// 获取所有闹钟任务，并加载它们各自关联的注册数据
  Future<List<AlarmTask>> getAllTasksWithNodes() async {
    try {
      final tasks = await _isar.alarmTasks.where().findAll();
      for (final task in tasks) {
        await task.timeNodeRegists.load();
      }
      return tasks;
    } catch (e) {
      print("获取所有闹钟任务及其注册数据失败: $e");
      rethrow;
    }
  }

  /// 获取单个闹钟任务的详情，并加载其所有注册数据
  Future<AlarmTask?> getTaskWithNodes(int taskId) async {
    try {
      final task = await _isar.alarmTasks.get(taskId);
      // 如果找到了任务，需要显式加载其关联的注册数据
      if (task != null) {
        await task.timeNodeRegists.load();
      }
      return task;
    } catch (e) {
      print("获取闹钟任务详情失败: $e");
      rethrow;
    }
  }

  /// 删除一个闹钟任务及其所有关联的注册数据
  Future<void> deleteTaskAndNodes(int taskId) async {
    try {
      await _isar.writeTxn(() async {
        final task = await getTaskWithNodes(taskId);
        if (task == null) return;

        // 获取所有关联注册节点的ID
        final registNodeIds = task.timeNodeRegists.map((node) => node.id).toList();
        // 批量删除所有注册节点
        await _isar.timeNodeRegists.deleteAll(registNodeIds);

        // 最后删除任务本身
        await _isar.alarmTasks.delete(taskId);
      });
    } catch (e) {
      print("删除闹钟任务及其注册数据失败: $e");
      rethrow;
    }
  }

  /// 更新一个闹钟任务（注意：这不会修改其关联的节点）
  Future<void> updateTask(AlarmTask task) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.alarmTasks.put(task);
      });
    } catch (e) {
      print("更新闹钟任务失败: $e");
      rethrow;
    }
  }
  
  /// 删除闹钟任务的所有注册节点
  Future<void> deleteRegistNodes(int taskId) async {
    try {
      await _isar.writeTxn(() async {
        final task = await getTaskWithNodes(taskId);
        if (task == null) return;

        // 获取所有关联注册节点的ID
        final registNodeIds = task.timeNodeRegists.map((node) => node.id).toList();
        // 批量删除所有注册节点
        await _isar.timeNodeRegists.deleteAll(registNodeIds);
        
        // 清空任务的注册节点链接
        task.timeNodeRegists.clear();
        await task.timeNodeRegists.save();
      });
    } catch (e) {
      print("删除闹钟任务的注册节点失败: $e");
      rethrow;
    }
  }
  
  /// 根据alarmSystemId查找TimeNodeRegist，并加载其关联的AlarmTask
  Future<TimeNodeRegist?> getTimeNodeRegistByAlarmSystemId(int alarmSystemId) async {
    try {
      final regist = await _isar.timeNodeRegists.filter()
        .alarmSystemIdEqualTo(alarmSystemId)
        .findFirst();
      
      // 如果找到了注册节点，需要显式加载其关联的AlarmTask
      if (regist != null) {
        await regist.alarmTask.load();
      }
      
      return regist;
    } catch (e) {
      print("根据alarmSystemId查找TimeNodeRegist失败: $e");
      rethrow;
    }
  }
}
