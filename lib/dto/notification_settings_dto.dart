import 'package:alarm/alarm.dart';
import 'package:equatable/equatable.dart';

/// 通知设置数据传输对象
class NotificationSettingsDto extends Equatable {
  /// 通知标题
  final String title;
  
  /// 通知内容
  final String body;
  
  /// 停止按钮文本（可选）
  final String? stopButton;
  
  /// 通知图标（可选）
  final String? icon;

  const NotificationSettingsDto({
    required this.title,
    required this.body,
    this.stopButton,
    this.icon,
  });

  @override
  List<Object?> get props => [title, body, stopButton, icon];

  /// 转换为 NotificationSettings 对象
  NotificationSettings toNotificationSettings() {
    return NotificationSettings(
      title: title,
      body: body,
      stopButton: stopButton,
      icon: icon,
    );
  }

  /// 从 NotificationSettings 创建 DTO
  factory NotificationSettingsDto.fromNotificationSettings(
    NotificationSettings settings,
  ) {
    return NotificationSettingsDto(
      title: settings.title,
      body: settings.body,
      stopButton: settings.stopButton,
      icon: settings.icon,
    );
  }

  /// 创建副本并修改部分属性
  NotificationSettingsDto copyWith({
    String? title,
    String? body,
    String? stopButton,
    String? icon,
  }) {
    return NotificationSettingsDto(
      title: title ?? this.title,
      body: body ?? this.body,
      stopButton: stopButton ?? this.stopButton,
      icon: icon ?? this.icon,
    );
  }
}