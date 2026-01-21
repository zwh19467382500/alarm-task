import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_alarm/bloc/alarm/alarm_bloc.dart';
import 'package:simple_alarm/bloc/alarm/alarm_event.dart';
import 'package:simple_alarm/dto/alarm_task_dto.dart';
import 'package:simple_alarm/entities/alarm_task.dart';
import 'package:simple_alarm/core/ui_theme.dart';
import 'package:flutter/services.dart';

// Using an enum for type safety and clarity
enum AlarmType { WakeUp, ClassBell, DrinkWater }

extension AlarmTypeExtension on AlarmType {
  String get displayName {
    switch (this) {
      case AlarmType.WakeUp:
        return '起床闹钟';
      case AlarmType.ClassBell:
        return '上课铃';
      case AlarmType.DrinkWater:
        return '喝水提醒';
    }
  }

  String get stringValue {
    return toString().split('.').last;
  }
}

AlarmType _stringToAlarmType(String type) {
  return AlarmType.values.firstWhere(
        (e) => e.stringValue == type,
    orElse: () => AlarmType.WakeUp,
  );
}

const Map<String, Map<String, String>> _formInstructions = {
  'WakeUp': {
    'title': '起床闹钟说明',
    'features': '• 设置起床时间\n• 支持贪睡间隔\n• 可选择重复日期\n• 自定义响铃声音',
    'tips': '建议设置多个贪睡间隔，逐步唤醒'
  },
  'ClassBell': {
    'title': '上课铃说明',
    'features': '• 设置首次响铃时间\n• 添加多个后续时间间隔\n• 适合课程表提醒\n• 支持自定义重复',
    'tips': '可根据课程表设置不同的时间间隔'
  },
  'DrinkWater': {
    'title': '喝水提醒说明',
    'features': '• 设置开始和结束时间\n• 自定义喝水间隔\n• 全天定时提醒\n• 保持健康作息',
    'tips': '建议每30-60分钟提醒一次喝水'
  }
};

class AlarmFormPage extends StatefulWidget {
  final AlarmTask? task;
  final String? alarmType;

  const AlarmFormPage({super.key, this.task, this.alarmType})
      : assert(task != null || alarmType != null, 'Either a task or an alarmType must be provided');

  @override
  State<AlarmFormPage> createState() => _AlarmFormPageState();
}

class _AlarmFormPageState extends State<AlarmFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Form state
  late AlarmType _selectedType;
  late TextEditingController _titleController;
  late TimeOfDay _selectedTime;
  late TextEditingController _intervalController;
  late TimeOfDay _selectedEndTime;
  List<TextEditingController> _classBellIntervalControllers = [];
  bool _soundEnabled = true;
  String _scheduleType = 'Once';
  List<int> _selectedDays = [];

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    final initialTypeString = widget.task?.type ?? widget.alarmType ?? 'WakeUp';
    _selectedType = _stringToAlarmType(initialTypeString);

    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _soundEnabled = widget.task?.soundEnabled ?? true;
    _scheduleType = widget.task?.scheduleType ?? 'Once';
    _selectedDays = List<int>.from(widget.task?.weekDays ?? []);

    // Initialize all controllers to avoid null errors when switching types
    _intervalController = TextEditingController();
    _selectedEndTime = TimeOfDay.now();
    _classBellIntervalControllers = [];

    if (widget.task != null) {
      // EDIT MODE: Populate all fields from task data
      final task = widget.task!;
      _selectedTime = _timeOfDayFromString(task.startTime, TimeOfDay.now());
      _intervalController.text = task.timeInterval?.toString() ?? '5';
      _selectedEndTime = _timeOfDayFromString(task.endTime, TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 3))));
      if (task.relativeTimes.isNotEmpty) {
        _classBellIntervalControllers = task.relativeTimes.map((t) => TextEditingController(text: t.toString())).toList();
      } else {
        _classBellIntervalControllers.add(TextEditingController(text: '5'));
      }
    } else {
      // CREATE MODE: Set smart defaults
      _selectedTime = TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 2)));
      _resetFormFieldsForType(_selectedType); // Set defaults based on the incoming type
    }

    // Set day selection based on schedule type
    if ((widget.task == null && _scheduleType == 'Once') || (widget.task != null && _scheduleType == 'Once' && _selectedDays.isEmpty)) {
      _selectedDays = [_getCurrentWeekday()];
    } else if (_scheduleType == 'Daily') {
      _selectedDays = [1, 2, 3, 4, 5, 6, 7];
    } else if (_scheduleType == 'Workday') {
      _selectedDays = [1, 2, 3, 4, 5];
    } else if (_scheduleType == 'Weekend') {
      _selectedDays = [6, 7];
    }
  }

  void _resetFormFieldsForType(AlarmType type) {
    // Reset fields to their default state for a given type
    _intervalController.text = '5';
    _selectedEndTime = TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 3)));
    
    // Dispose old controllers before creating new ones
    for (var controller in _classBellIntervalControllers) {
      controller.dispose();
    }
    _classBellIntervalControllers = [TextEditingController(text: '5')];
  }

  void _onTypeChanged(AlarmType? newType) {
    if (newType == null) return;
    setState(() {
      _selectedType = newType;
      _resetFormFieldsForType(newType);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _intervalController.dispose();
    for (var controller in _classBellIntervalControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveAlarm() {
    if (!_formKey.currentState!.validate()) return;

    // 如果标题为空，使用闹钟类型的显示名称作为默认值
    if (_titleController.text.isEmpty) {
      _titleController.text = _selectedType.displayName;
    }

    int? timeInterval;
    List<int> relativeTimes = [];
    String? endTime;

    switch (_selectedType) {
      case AlarmType.ClassBell:
        relativeTimes = _classBellIntervalControllers
            .map((c) => int.tryParse(c.text) ?? 0)
            .where((t) => t > 0)
            .toList();
        break;
      case AlarmType.DrinkWater:
        timeInterval = int.tryParse(_intervalController.text) ?? 5;
        endTime = _timeOfDayToString(_selectedEndTime);
        break;
      case AlarmType.WakeUp:
        timeInterval = int.tryParse(_intervalController.text) ?? 5;
        break;
    }

    final dto = AlarmTaskDto(
      id: widget.task?.id,
      title: _titleController.text,
      type: _selectedType.stringValue,
      soundEnabled: _soundEnabled,
      scheduleType: _scheduleType,
      weekDays: _selectedDays,
      timeInterval: timeInterval,
      startTime: _timeOfDayToString(_selectedTime),
      endTime: endTime,
      relativeTimes: relativeTimes,
    );

    context.read<AlarmBloc>().add(AlarmSaved(dto));
    Navigator.of(context).pop();
  }
  
  // Helper methods
  TimeOfDay _timeOfDayFromString(String? timeString, TimeOfDay fallback) {
    if (timeString == null) return fallback;
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _timeOfDayToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null && picked != _selectedTime) setState(() => _selectedTime = picked);
  }

  Future<void> _selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: _selectedEndTime);
    if (picked != null && picked != _selectedEndTime) setState(() => _selectedEndTime = picked);
  }

  void _addClassBellInterval() {
    setState(() => _classBellIntervalControllers.add(TextEditingController(text: '5')));
  }

  void _removeClassBellInterval(int index) {
    setState(() {
      _classBellIntervalControllers[index].dispose();
      _classBellIntervalControllers.removeAt(index);
    });
  }

  void _toggleDay(int day) {
    setState(() {
      if (_scheduleType != 'Custom') _scheduleType = 'Custom';
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  void _selectScheduleType(String type) {
    setState(() {
      _scheduleType = type;
      if (type == 'Daily') {
        _selectedDays = [1, 2, 3, 4, 5, 6, 7];
      } else if (type == 'Workday') {
        _selectedDays = [1, 2, 3, 4, 5];
      } else if (type == 'Weekend') {
        _selectedDays = [6, 7];
      } else if (type == 'Once') {
        _selectedDays = [_getCurrentWeekday()];
      } else {
        _selectedDays.clear();
      }
    });
  }

  int _getCurrentWeekday() => DateTime.now().weekday;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? '新建闹钟' : '编辑闹钟'),
        actions: [IconButton(icon: const Icon(Icons.save), onPressed: _saveAlarm, tooltip: '保存')],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type Selector
              SegmentedButton<AlarmType>(
                segments: AlarmType.values.map((type) {
                  return ButtonSegment<AlarmType>(
                    value: type,
                    label: Text(type.displayName),
                  );
                }).toList(),
                selected: {_selectedType},
                onSelectionChanged: (newSelection) => _onTypeChanged(newSelection.first),
                multiSelectionEnabled: false,
                showSelectedIcon: false,
                style: const ButtonStyle(visualDensity: VisualDensity(horizontal: -2, vertical: -2)),
              ),
              const SizedBox(height: 24),

              // Instruction Card
              _buildInstructionCard(),
              const SizedBox(height: 24),

              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: '闹钟标题', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),

              // Time selection based on type
              _buildTimeFields(),
              const Divider(),
              const SizedBox(height: 16),

              // Repetition
              const Text('重复', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(label: const Text('仅一次'), selected: _scheduleType == 'Once', onSelected: (_) => _selectScheduleType('Once')),
                  ChoiceChip(label: const Text('每天'), selected: _scheduleType == 'Daily', onSelected: (_) => _selectScheduleType('Daily')),
                  ChoiceChip(label: const Text('工作日'), selected: _scheduleType == 'Workday', onSelected: (_) => _selectScheduleType('Workday')),
                  ChoiceChip(label: const Text('周末'), selected: _scheduleType == 'Weekend', onSelected: (_) => _selectScheduleType('Weekend')),
                  ChoiceChip(label: const Text('自定义'), selected: _scheduleType == 'Custom', onSelected: (_) => _selectScheduleType('Custom')),
                ],
              ),
              const SizedBox(height: 16),

              // Day selector for custom repetition
              if (_scheduleType == 'Custom' || _scheduleType == 'Workday' || _scheduleType == 'Weekend')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('星期', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: List.generate(7, (i) {
                        final day = i + 1;
                        final labels = ['一', '二', '三', '四', '五', '六', '日'];
                        return FilterChip(
                          label: Text(labels[i]),
                          selected: _selectedDays.contains(day),
                          onSelected: (_) => _toggleDay(day),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),

              // Sound toggle
              SwitchListTile(
                title: const Text('响铃'),
                value: _soundEnabled,
                onChanged: (value) => setState(() => _soundEnabled = value),
              ),
              const SizedBox(height: 16),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveAlarm,
                  child: Text(widget.task == null ? '创建闹钟' : '保存更改'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Instruction Card Widget
  Widget _buildInstructionCard() {
    final instruction = _formInstructions[_selectedType.stringValue] ?? _formInstructions['WakeUp']!;
    final typeColor = AppUITheme.getAlarmTypeColor(_selectedType.stringValue);
    final typeIcon = AppUITheme.getAlarmTypeIcon(_selectedType.stringValue);

    return AnimatedContainer(
      duration: AppUITheme.animationDuration,
      curve: AppUITheme.easeInOutCurve,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppUITheme.alarmTypeGradient(_selectedType.stringValue),
        ),
        child: Container(
          decoration: AppUITheme.standardCardDecoration(
            borderColor: typeColor.withAlpha(100),
            shadows: AppUITheme.lightShadow,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppUITheme.mediumPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 顶部标题栏 - 带动画
                AnimatedContainer(
                  duration: AppUITheme.animationDuration,
                  curve: AppUITheme.easeOutCurve,
                  decoration: BoxDecoration(
                    color: typeColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(AppUITheme.smallBorderRadius),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppUITheme.mediumPadding,
                    vertical: AppUITheme.smallPadding,
                  ),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: AppUITheme.animationDuration,
                        curve: Curves.elasticOut,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: typeColor.withAlpha(30),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            typeIcon,
                            color: typeColor,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppUITheme.smallPadding),
                      Expanded(
                        child: AnimatedDefaultTextStyle(
                          duration: AppUITheme.animationDuration,
                          curve: AppUITheme.easeOutCurve,
                          style: AppUITheme.sectionTitleStyle.copyWith(
                            color: typeColor,
                            fontWeight: FontWeight.bold,
                          ),
                          child: Text(
                            instruction['title']!,
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: AppUITheme.animationDuration,
                        curve: Curves.bounceOut,
                        child: Icon(
                          Icons.info_outline,
                          color: typeColor,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppUITheme.mediumPadding),
                
                // 功能特点 - 带滑入动画
                AnimatedContainer(
                  duration: AppUITheme.animationDuration,
                  curve: AppUITheme.easeOutCurve,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '功能特点',
                        style: AppUITheme.sectionTitleStyle,
                      ),
                      const SizedBox(height: AppUITheme.smallPadding),
                      AnimatedDefaultTextStyle(
                        duration: AppUITheme.animationDuration,
                        curve: AppUITheme.easeOutCurve,
                        style: AppUITheme.bodyTextStyle,
                        child: Text(
                          instruction['features']!,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppUITheme.mediumPadding),
                
                // 小贴士 - 带脉冲动画效果
                AnimatedContainer(
                  duration: AppUITheme.animationDuration,
                  curve: AppUITheme.easeOutCurve,
                  padding: const EdgeInsets.all(AppUITheme.mediumPadding),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(AppUITheme.smallBorderRadius),
                    border: Border.all(
                      color: Colors.amber[200]!,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        duration: AppUITheme.animationDuration,
                        curve: Curves.bounceOut,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.amber[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.lightbulb,
                            color: Colors.amber[700],
                            size: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppUITheme.smallPadding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedDefaultTextStyle(
                              duration: AppUITheme.animationDuration,
                              curve: AppUITheme.easeOutCurve,
                              style: AppUITheme.sectionTitleStyle.copyWith(
                                fontSize: 12,
                                color: Colors.amber[900],
                              ),
                              child: Text(
                                '小贴士',
                              ),
                            ),
                            const SizedBox(height: AppUITheme.tinyPadding),
                            AnimatedDefaultTextStyle(
                              duration: AppUITheme.animationDuration,
                              curve: AppUITheme.easeOutCurve,
                              style: AppUITheme.captionTextStyle.copyWith(
                                color: Colors.amber[800],
                              ),
                              child: Text(
                                instruction['tips']!,
                              ),
                            ),
                          ],
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

  // Widget builder for dynamic form part
  Widget _buildTimeFields() {
    switch (_selectedType) {
      case AlarmType.WakeUp:
        return Column(children: [
          ListTile(title: const Text('闹钟时间'), trailing: Text(_timeOfDayToString(_selectedTime), style: Theme.of(context).textTheme.headlineSmall), onTap: _selectTime),
          const SizedBox(height: 16),
          TextFormField(
            controller: _intervalController,
            decoration: const InputDecoration(labelText: '贪睡时间间隔(分钟)', border: OutlineInputBorder(), helperText: '连续响铃间隔，设置为0则只响一次'),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) => (v == null || v.isEmpty || int.tryParse(v) == null || int.parse(v) < 0) ? '请输入有效的间隔时间' : null,
          ),
        ]);
      case AlarmType.DrinkWater:
        return Column(children: [
          ListTile(title: const Text('开始时间'), trailing: Text(_timeOfDayToString(_selectedTime), style: Theme.of(context).textTheme.headlineSmall), onTap: _selectTime),
          ListTile(title: const Text('结束时间'), trailing: Text(_timeOfDayToString(_selectedEndTime), style: Theme.of(context).textTheme.headlineSmall), onTap: _selectEndTime),
          const SizedBox(height: 16),
          TextFormField(
            controller: _intervalController,
            decoration: const InputDecoration(labelText: '间隔时间(分钟)', border: OutlineInputBorder(), helperText: '连续响铃间隔'),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) => (v == null || v.isEmpty || int.tryParse(v) == null || int.parse(v) <= 0) ? '请输入大于0的间隔时间' : null,
          ),
        ]);
      case AlarmType.ClassBell:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(title: const Text('首次响铃时间'), trailing: Text(_timeOfDayToString(_selectedTime), style: Theme.of(context).textTheme.headlineSmall), onTap: _selectTime),
            const SizedBox(height: 16),
            const Text('后续贪睡间隔(分钟)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._classBellIntervalControllers.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(child: TextFormField(
                      controller: entry.value,
                      decoration: InputDecoration(labelText: '时间间隔 ${entry.key + 1}', border: const OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) => (v == null || v.isEmpty || int.tryParse(v) == null || int.parse(v) <= 0) ? '请输入大于0的间隔' : null,
                    )),
                    if (_classBellIntervalControllers.length > 1)
                      IconButton(icon: const Icon(Icons.remove_circle_outline, color: Colors.red), onPressed: () => _removeClassBellInterval(entry.key)),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            ElevatedButton.icon(onPressed: _addClassBellInterval, icon: const Icon(Icons.add), label: const Text('添加时间间隔')),
          ],
        );
    }
  }
}
