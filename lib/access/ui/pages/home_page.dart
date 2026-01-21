import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_alarm/access/ui/widgets/app_drawer.dart';
import 'package:simple_alarm/bloc/alarm/alarm_bloc.dart';
import 'package:simple_alarm/bloc/alarm/alarm_event.dart';
import 'package:simple_alarm/bloc/alarm/alarm_state.dart';
import 'package:simple_alarm/access/ui/pages/alarm_form_page.dart';
import 'package:simple_alarm/access/ui/widgets/alarm_list_page.dart';
import 'package:simple_alarm/service/jpush_util.dart';
import 'package:simple_alarm/service_locator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final jPushUtil = locator<JPushUtil>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // 页面加载时，自动触发加载闹钟列表的事件
    context.read<AlarmBloc>().add(AlarmsLoaded());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 显示推送测试对话框
  void _showPushTestDialog(BuildContext context) {
    final aliasController = TextEditingController();
    final tagController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('推送测试'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: aliasController,
              decoration: const InputDecoration(
                labelText: '设置别名',
                hintText: '输入别名',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: tagController,
              decoration: const InputDecoration(
                labelText: '设置标签',
                hintText: '输入标签，多个标签用逗号分隔',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (aliasController.text.isNotEmpty) {
                jPushUtil.setAlias(aliasController.text);
              }
              if (tagController.text.isNotEmpty) {
                List<String> tags = tagController.text.split(',')
                    .map((tag) => tag.trim())
                    .where((tag) => tag.isNotEmpty)
                    .toList();
                if (tags.isNotEmpty) {
                  jPushUtil.setTags(tags);
                }
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('我的闹钟'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: '推送测试',
            onPressed: () {
              _showPushTestDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '创建闹钟',
            onPressed: () {
              // 根据当前tab确定闹钟类型
              final alarmTypes = ['WakeUp', 'ClassBell', 'DrinkWater'];
              final currentType = alarmTypes[_tabController.index];
              
              // 使用BlocProvider.value传递现有的AlarmBloc实例
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: context.read<AlarmBloc>(),
                    child: AlarmFormPage(alarmType: currentType),
                  ),
                ),
              );
            },
          ),
          
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '起床闹钟'),
            Tab(text: '上课铃'),
            Tab(text: '喝水提醒'),
          ],
        ),
      ),
      body: BlocListener<AlarmBloc, AlarmState>(
        listener: (context, state) {
          if (state is AlarmActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), duration: const Duration(seconds: 1)),
            );
          } else if (state is AlarmActionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error, style: const TextStyle(color: Colors.red))),
            );
          } else if (state is ShowPushMessagePopup) {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext bottomSheetContext) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('收到推送消息:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          const JsonEncoder.withIndent('  ').convert(state.message),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
        child: BlocBuilder<AlarmBloc, AlarmState>(
          buildWhen: (previous, current) {
            // 只在UI内容需要实际改变的状态下才重建
            // 忽略那些只用于触发一次性事件（如SnackBar或弹窗）的状态
            return current is! AlarmActionSuccess && 
                   current is! AlarmActionFailure && 
                   current is! ShowPushMessagePopup;
          },
          builder: (context, state) {
            if (state is AlarmInProgress) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AlarmsLoadFailure) {
              return Center(child: Text('加载失败: ${state.error}'));
            }
            if (state is AlarmsLoadSuccess) {
              final tasks = state.tasks;
              return TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: WakeUp
                  AlarmListPage(
                    tasks: tasks.where((t) => t.type == 'WakeUp').toList(),
                    alarmType: 'WakeUp',
                  ),
                  // Tab 2: ClassBell
                  AlarmListPage(
                    tasks: tasks.where((t) => t.type == 'ClassBell').toList(),
                    alarmType: 'ClassBell',
                  ),
                  // Tab 3: DrinkWater
                  AlarmListPage(
                    tasks: tasks.where((t) => t.type == 'DrinkWater').toList(),
                    alarmType: 'DrinkWater',
                  ),
                ],
              );
            }
            return const Center(child: Text('点击加载...')); // Initial or unknown state
          },
        ),
      ),
    );
  }
}
