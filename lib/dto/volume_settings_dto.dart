import 'package:alarm/alarm.dart';
import 'package:equatable/equatable.dart';

/// 音量设置数据传输对象
class VolumeSettingsDto extends Equatable {
  /// 音量值（0.0 到 1.0，可选）
  final double? volume;
  
  /// 淡入持续时间（可选）
  final Duration? fadeDuration;

  const VolumeSettingsDto({
    this.volume,
    this.fadeDuration,
  });

  @override
  List<Object?> get props => [volume, fadeDuration];

  /// 转换为 VolumeSettings 对象
  VolumeSettings toVolumeSettings() {
    return VolumeSettings.fade(
      volume: volume, // 直接使用设置的音量值，如果为 null 则使用系统默认音量
      fadeDuration: fadeDuration ?? Duration.zero, // 如果 fadeDuration 为 null，则不使用淡入效果
      volumeEnforced: false, // 不强制音量，允许用户在闹钟响铃期间调整音量
    );
  }

  /// 从 VolumeSettings 创建 DTO
  factory VolumeSettingsDto.fromVolumeSettings(VolumeSettings settings) {
    return VolumeSettingsDto(
      volume: settings.volume,
      fadeDuration: settings.fadeDuration,
    );
  }

  /// 从 JSON 创建 DTO
  factory VolumeSettingsDto.fromJson(Map<String, dynamic> json) {
    return VolumeSettingsDto(
      volume: json['volume']?.toDouble(),
      fadeDuration: json['fadeDuration'] != null
          ? Duration(milliseconds: (json['fadeDuration'] as num).toInt())
          : null,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'volume': volume,
      'fadeDuration': fadeDuration?.inMilliseconds,
    };
  }

  /// 创建副本并修改部分属性
  VolumeSettingsDto copyWith({
    double? volume,
    Duration? fadeDuration,
  }) {
    return VolumeSettingsDto(
      volume: volume ?? this.volume,
      fadeDuration: fadeDuration ?? this.fadeDuration,
    );
  }
}