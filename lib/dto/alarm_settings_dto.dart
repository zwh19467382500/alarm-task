import 'package:alarm/alarm.dart';
import 'package:equatable/equatable.dart';
import 'notification_settings_dto.dart';
import 'volume_settings_dto.dart';

/// 闹钟设置数据传输对象
/// 封装了 AlarmSettings 的所有可配置参数
class AlarmSettingsDto extends Equatable {
  /// 闹钟唯一标识符
  final int id;

  /// 闹钟触发时间
  final DateTime dateTime;

  /// 音频文件路径
  final String assetAudioPath;

  /// 是否循环播放音频
  final bool loopAudio;

  /// 是否震动
  final bool vibrate;

  /// 通知设置
  final NotificationSettingsDto notificationSettings;

  /// 音量设置
  final VolumeSettingsDto volumeSettings;

  /// 是否启用 Android 全屏意图（可选）
  final bool? androidFullScreenIntent;

  /// 是否在应用被杀死时显示通知（可选）
  final bool? enableNotificationOnKill;

  /// 淡入持续时间（秒，可选）
  final double? fadeDuration;

  /// 音频文件的音量（0.0 到 1.0，可选）
  final double? volume;

  const AlarmSettingsDto({
    required this.id,
    required this.dateTime,
    required this.assetAudioPath,
    this.loopAudio = true,
    this.vibrate = true,
    required this.notificationSettings,
    required this.volumeSettings,
    this.androidFullScreenIntent,
    this.enableNotificationOnKill,
    this.fadeDuration,
    this.volume,
  });

  @override
  List<Object?> get props => [
        id,
        dateTime,
        assetAudioPath,
        loopAudio,
        vibrate,
        notificationSettings,
        volumeSettings,
        androidFullScreenIntent,
        enableNotificationOnKill,
        fadeDuration,
        volume,
      ];

  /// 转换为 AlarmSettings 对象
  AlarmSettings toAlarmSettings() {
    return AlarmSettings(
      id: id,
      dateTime: dateTime,
      assetAudioPath: assetAudioPath,
      loopAudio: loopAudio,
      vibrate: vibrate,
      notificationSettings: notificationSettings.toNotificationSettings(),
      volumeSettings: volumeSettings.toVolumeSettings(),
    );
  }

  /// 从 AlarmSettings 创建 DTO
  factory AlarmSettingsDto.fromAlarmSettings(AlarmSettings settings) {
    return AlarmSettingsDto(
      id: settings.id,
      dateTime: settings.dateTime,
      assetAudioPath: settings.assetAudioPath,
      loopAudio: settings.loopAudio,
      vibrate: settings.vibrate,
      notificationSettings: NotificationSettingsDto.fromNotificationSettings(
        settings.notificationSettings,
      ),
      volumeSettings: VolumeSettingsDto.fromVolumeSettings(
        settings.volumeSettings,
      ),
    );
  }

  /// 创建副本并修改部分属性
  AlarmSettingsDto copyWith({
    int? id,
    DateTime? dateTime,
    String? assetAudioPath,
    bool? loopAudio,
    bool? vibrate,
    NotificationSettingsDto? notificationSettings,
    VolumeSettingsDto? volumeSettings,
    bool? androidFullScreenIntent,
    bool? enableNotificationOnKill,
    double? fadeDuration,
    double? volume,
  }) {
    return AlarmSettingsDto(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      assetAudioPath: assetAudioPath ?? this.assetAudioPath,
      loopAudio: loopAudio ?? this.loopAudio,
      vibrate: vibrate ?? this.vibrate,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      volumeSettings: volumeSettings ?? this.volumeSettings,
      androidFullScreenIntent:
          androidFullScreenIntent ?? this.androidFullScreenIntent,
      enableNotificationOnKill:
          enableNotificationOnKill ?? this.enableNotificationOnKill,
      fadeDuration: fadeDuration ?? this.fadeDuration,
      volume: volume ?? this.volume,
    );
  }
}
