import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_alarm/bloc/alarm/alarm_bloc.dart';
import 'package:simple_alarm/bloc/alarm/alarm_event.dart';
import 'package:simple_alarm/entities/alarm_task.dart';
import 'package:simple_alarm/service/alarm_service.dart';
import 'package:simple_alarm/service_locator.dart';
import 'package:simple_alarm/core/ui_theme.dart';
import 'package:simple_alarm/access/ui/pages/alarm_form_page.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class AlarmTaskCard extends StatefulWidget {
  final AlarmTask task;

  const AlarmTaskCard({super.key, required this.task});

  @override
  State<AlarmTaskCard> createState() => _AlarmTaskCardState();
}

class _AlarmTaskCardState extends State<AlarmTaskCard> {
  Duration? _countdown;
  Timer? _timer;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // 根据任务状态决定是否启动定时器
    if (widget.task.isActive) {
      _startTimer();
    }
    // 加载初始倒计时
    _loadInitialCountdown();
  }
  
  @override
  void didUpdateWidget(covariant AlarmTaskCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // 检查任务状态是否发生变化
    if (oldWidget.task.isActive != widget.task.isActive) {
      if (widget.task.isActive) {
        // 任务变为激活状态，启动定时器
        _startTimer();
      } else {
        // 任务变为非激活状态，停止定时器
        _stopTimer();
      }
      
      // 重新加载倒计时以反映状态变化
      setState(() {
        _isLoading = true;
        _loadInitialCountdown();
      });
    }
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _stopTimer(); // 确保之前的定时器已停止
    
    // 只有当任务激活时才启动定时器
    if (widget.task.isActive) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdown != null) {
            _countdown = _countdown! - const Duration(seconds: 1);
            
            // 如果倒计时结束，重新加载
            if (_countdown!.inSeconds <= 0) {
              _isLoading = true;
              _loadInitialCountdown();
            }
          } else {
            // 当_countdown为null时，设置加载状态并直接调用_loadInitialCountdown()
            _isLoading = true;
            _loadInitialCountdown();
          }
        });
      });
    }
  }
  
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _loadInitialCountdown() async {
    try {
      final duration = await locator<AlarmService>().calculateCountdown(widget.task.id);
      setState(() {
        _isLoading = false;
        if (duration != null) {
          _countdown = duration;
          _errorMessage = '';
        } else {
          // 当duration为null时，不设置错误信息，让UI显示"已过期或未激活"
          _countdown = null;
          _errorMessage = '';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = '加载倒计时失败: $e';
        _countdown = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = AppUITheme.getAlarmTypeColor(widget.task.type ?? 'WakeUp');
    final typeIcon = AppUITheme.getAlarmTypeIcon(widget.task.type ?? 'WakeUp');

    return AnimatedContainer(
      duration: AppUITheme.animationDuration,
      curve: AppUITheme.easeInOutCurve,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: AppUITheme.alarmTypeGradient(widget.task.type ?? 'WakeUp'),
      ),
      child: AnimatedContainer(
        duration: AppUITheme.animationDuration,
        curve: AppUITheme.easeOutCurve,
        decoration: AppUITheme.standardCardDecoration(
          borderColor: typeColor.withAlpha(100),
          shadows: AppUITheme.lightShadow,
        ),
        child: InkWell(
          onTap: () {
            // 使用BlocProvider.value传递现有的AlarmBloc实例
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: context.read<AlarmBloc>(),
                  child: AlarmFormPage(task: widget.task),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(AppUITheme.largeBorderRadius),
          child: Padding(
            padding: const EdgeInsets.all(AppUITheme.mediumPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 顶部标题栏 - 带动画
                AnimatedContainer(
                  duration: AppUITheme.animationDuration,
                  curve: AppUITheme.easeOutCurve,
                  child: Row(
                    children: [
                      // 类型图标 - 带缩放动画
                      AnimatedContainer(
                        duration: AppUITheme.animationDuration,
                        curve: Curves.elasticOut,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: typeColor.withAlpha(20),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            typeIcon,
                            color: typeColor,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppUITheme.smallPadding),
                      
                      // 标题 - 带淡入动画
                      Expanded(
                        child: AnimatedDefaultTextStyle(
                          duration: AppUITheme.animationDuration,
                          curve: AppUITheme.easeOutCurve,
                          style: AppUITheme.cardTitleStyle,
                          child: Text(
                            widget.task.title ?? '无标题',
                          ),
                        ),
                      ),
                      
                      // 开关 - 带动画
                      AnimatedSwitcher(
                        duration: AppUITheme.fastAnimationDuration,
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Switch(
                          key: ValueKey(widget.task.isActive),
                          value: widget.task.isActive,
                          onChanged: (newValue) {
                            context.read<AlarmBloc>().add(AlarmStatusToggled(widget.task.id));
                          },
                          activeColor: typeColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppUITheme.mediumPadding),

                // 状态标签和信息 - 带滑入动画
                AnimatedContainer(
                  duration: AppUITheme.animationDuration,
                  curve: AppUITheme.easeOutCurve,
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: AppUITheme.animationDuration,
                        curve: AppUITheme.easeOutCurve,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppUITheme.smallPadding,
                          vertical: AppUITheme.tinyPadding,
                        ),
                        decoration: BoxDecoration(
                          color: widget.task.isActive 
                              ? Colors.green[50] 
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(AppUITheme.smallBorderRadius),
                        ),
                        child: AnimatedDefaultTextStyle(
                          duration: AppUITheme.animationDuration,
                          curve: AppUITheme.easeOutCurve,
                          style: AppUITheme.captionTextStyle.copyWith(
                            color: widget.task.isActive 
                                ? Colors.green[700] 
                                : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          child: Text(
                            widget.task.isActive ? '已启用' : '已禁用',
                          ),
                        ),
                      ),
                      const SizedBox(width: AppUITheme.smallPadding),
                      AnimatedDefaultTextStyle(
                        duration: AppUITheme.animationDuration,
                        curve: AppUITheme.easeOutCurve,
                        style: AppUITheme.captionTextStyle,
                        child: Text(
                          '开始时间: ${widget.task.startTime ?? '未设置'}',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppUITheme.mediumPadding),

                // 时间点显示 - 带动画
                if (widget.task.timeNodeRegists.isNotEmpty) ...[
                  AnimatedContainer(
                    duration: AppUITheme.animationDuration,
                    curve: AppUITheme.easeOutCurve,
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: AppUITheme.animationDuration,
                          curve: Curves.bounceOut,
                          child: Icon(
                            Icons.access_time,
                            color: typeColor,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: AppUITheme.tinyPadding),
                        Text(
                          '时间点',
                          style: AppUITheme.sectionTitleStyle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppUITheme.smallPadding),
                  AnimatedContainer(
                    duration: AppUITheme.animationDuration,
                    curve: AppUITheme.easeOutCurve,
                    child: Wrap(
                      spacing: AppUITheme.smallPadding,
                      runSpacing: AppUITheme.tinyPadding,
                      children: widget.task.timeNodeRegists.map((regist) {
                        final formattedTime = DateFormat('MM-dd HH:mm').format(regist.exactDateTime);
                        return AnimatedContainer(
                          duration: AppUITheme.animationDuration,
                          curve: AppUITheme.easeOutCurve,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppUITheme.smallPadding,
                            vertical: AppUITheme.tinyPadding,
                          ),
                          decoration: BoxDecoration(
                            color: regist.isHead 
                                ? typeColor.withAlpha(30) 
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(AppUITheme.smallBorderRadius),
                            border: Border.all(
                              color: regist.isHead 
                                  ? typeColor.withAlpha(100) 
                                  : Colors.grey.withAlpha(50),
                            ),
                          ),
                          child: AnimatedDefaultTextStyle(
                            duration: AppUITheme.animationDuration,
                            curve: AppUITheme.easeOutCurve,
                            style: AppUITheme.captionTextStyle.copyWith(
                              color: regist.isHead 
                                  ? typeColor 
                                  : Colors.grey[700],
                              fontWeight: regist.isHead 
                                  ? FontWeight.w600 
                                  : FontWeight.normal,
                            ),
                            child: Text(
                              formattedTime,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: AppUITheme.mediumPadding),
                ],

                // 底部倒计时和删除按钮 - 带动画
                AnimatedContainer(
                  duration: AppUITheme.animationDuration,
                  curve: AppUITheme.easeOutCurve,
                  child: Row(
                    children: [
                      // 倒计时显示 - 带脉冲动画
                      Expanded(
                        child: AnimatedContainer(
                          duration: AppUITheme.animationDuration,
                          curve: AppUITheme.easeOutCurve,
                          padding: const EdgeInsets.all(AppUITheme.smallPadding),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(AppUITheme.smallBorderRadius),
                          ),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: AppUITheme.animationDuration,
                                curve: Curves.bounceOut,
                                child: Icon(
                                  Icons.notifications_active,
                                  color: typeColor,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: AppUITheme.tinyPadding),
                              Expanded(
                                child: AnimatedSwitcher(
                                  duration: AppUITheme.fastAnimationDuration,
                                  child: _isLoading
                                      ? Text(
                                          '计算中...',
                                          key: const ValueKey('loading'),
                                          style: AppUITheme.captionTextStyle.copyWith(
                                            color: Colors.grey[600],
                                          ),
                                        )
                                      : _errorMessage.isNotEmpty
                                          ? Text(
                                              _errorMessage,
                                              key: ValueKey('error'),
                                              style: AppUITheme.captionTextStyle.copyWith(
                                                color: Colors.red[600],
                                              ),
                                            )
                                          : _countdown == null
                                              ? Text(
                                                  '已过期或未激活',
                                                  key: const ValueKey('expired'),
                                                  style: AppUITheme.captionTextStyle.copyWith(
                                                    color: Colors.grey[600],
                                                  ),
                                                )
                                              : Text(
                                                  '下次响铃: ${_countdown!.inHours}小时${_countdown!.inMinutes.remainder(60)}分${_countdown!.inSeconds.remainder(60)}秒后',
                                                  key: ValueKey('countdown_${_countdown!.inSeconds}'),
                                                  style: AppUITheme.captionTextStyle.copyWith(
                                                    color: Colors.green[700],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: AppUITheme.smallPadding),
                      
                      // 删除按钮 - 带缩放动画
                      AnimatedContainer(
                        duration: AppUITheme.animationDuration,
                        curve: Curves.elasticOut,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: AnimatedSwitcher(
                              duration: AppUITheme.fastAnimationDuration,
                              transitionBuilder: (Widget child, Animation<double> animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                              child: Icon(
                                Icons.delete_outline,
                                color: Colors.red[400],
                                size: 18,
                                key: const ValueKey('delete'),
                              ),
                            ),
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('确认删除'),
                                    content: Text('确定要删除"${widget.task.title ?? '无标题'}"的闹钟任务吗？'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('取消'),
                                        onPressed: () => Navigator.of(context).pop(false),
                                      ),
                                      TextButton(
                                        child: const Text('确定'),
                                        onPressed: () => Navigator.of(context).pop(true),
                                      ),
                                    ],
                                  );
                                },
                              );
                              
                              if (confirmed == true) {
                                if (context.mounted) {
                                  context.read<AlarmBloc>().add(AlarmDeleted(widget.task.id));
                                }
                              }
                            },
                          ),
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
    );
  }
}
