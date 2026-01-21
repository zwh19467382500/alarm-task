import 'package:flutter/material.dart';
import 'package:simple_alarm/entities/alarm_task.dart';
import 'package:simple_alarm/core/ui_theme.dart';
import 'alarm_task_card.dart';

class AlarmListPage extends StatelessWidget {
  final List<AlarmTask> tasks;
  final String alarmType;

  const AlarmListPage({super.key, required this.tasks, required this.alarmType});

  static const Map<String, Map<String, String>> _instructions = {
    'WakeUp': {
      'title': '起床闹钟',
      'description': '设置早晨起床时间，支持贪睡功能',
      'guide': '点击右上角 + 号创建新的起床闹钟',
      'features': '• 设置起床时间\n• 支持贪睡间隔\n• 可选择重复日期\n• 自定义响铃声音'
    },
    'ClassBell': {
      'title': '上课铃',
      'description': '设置上课时间提醒，支持多个时间间隔',
      'guide': '点击右上角 + 号创建新的上课铃声',
      'features': '• 设置首次响铃时间\n• 添加多个后续时间间隔\n• 适合课程表提醒\n• 支持自定义重复'
    },
    'DrinkWater': {
      'title': '喝水提醒',
      'description': '设置定时喝水提醒，保持健康作息',
      'guide': '点击右上角 + 号创建新的喝水提醒',
      'features': '• 设置开始和结束时间\n• 自定义喝水间隔\n• 全天定时提醒\n• 保持健康作息'
    }
  };

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return AlarmTaskCard(task: tasks[index]);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final instruction = _instructions[alarmType] ?? _instructions['WakeUp']!;
    final typeColor = AppUITheme.getAlarmTypeColor(alarmType);
    final typeIcon = AppUITheme.getAlarmTypeIcon(alarmType);

    return Container(
      decoration: BoxDecoration(
        gradient: AppUITheme.alarmTypeGradient(alarmType),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppUITheme.largePadding),
          child: AnimatedContainer(
            duration: AppUITheme.animationDuration,
            curve: AppUITheme.easeInOutCurve,
            child: Container(
              decoration: AppUITheme.standardCardDecoration(
                borderColor: typeColor.withAlpha(100),
                shadows: AppUITheme.mediumShadow,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppUITheme.largePadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 顶部图标区域 - 带缩放动画
                    AnimatedContainer(
                      duration: AppUITheme.animationDuration,
                      curve: Curves.elasticOut,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: typeColor.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          typeIcon,
                          size: 40,
                          color: typeColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppUITheme.largePadding),
                    
                    // 标题 - 带淡入动画
                    AnimatedDefaultTextStyle(
                      duration: AppUITheme.animationDuration,
                      curve: AppUITheme.easeOutCurve,
                      style: AppUITheme.cardTitleStyle,
                      child: Text(
                        instruction['title']!,
                      ),
                    ),
                    const SizedBox(height: AppUITheme.mediumPadding),
                    
                    // 描述 - 带淡入动画
                    AnimatedDefaultTextStyle(
                      duration: AppUITheme.animationDuration,
                      curve: AppUITheme.easeOutCurve,
                      style: AppUITheme.bodyTextStyle,
                      child: Text(
                        instruction['description']!,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppUITheme.largePadding),
                    
                    // 功能特点 - 带滑入动画
                    AnimatedContainer(
                      duration: AppUITheme.animationDuration,
                      curve: AppUITheme.easeOutCurve,
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppUITheme.mediumPadding),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(AppUITheme.mediumBorderRadius),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '功能特点',
                            style: AppUITheme.sectionTitleStyle,
                          ),
                          const SizedBox(height: AppUITheme.smallPadding),
                          Text(
                            instruction['features']!,
                            style: AppUITheme.bodyTextStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppUITheme.largePadding),
                    
                    // 操作指引 - 带淡入动画
                    AnimatedContainer(
                      duration: AppUITheme.animationDuration,
                      curve: AppUITheme.easeOutCurve,
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: AppUITheme.animationDuration,
                            curve: Curves.bounceOut,
                            child: Icon(
                              Icons.touch_app,
                              color: typeColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: AppUITheme.smallPadding),
                          Expanded(
                            child: Text(
                              instruction['guide']!,
                              style: AppUITheme.captionTextStyle,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
