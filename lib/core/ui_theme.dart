import 'package:flutter/material.dart';

/// 应用统一的UI主题和样式常量
class AppUITheme {
  // 私有构造函数，防止实例化
  const AppUITheme._();

  // 统一的动画曲线
  static const Curve easeInOutCurve = Curves.easeInOut;
  static const Curve easeOutCurve = Curves.easeOut;
  static const Curve easeInCurve = Curves.easeIn;
  static const Curve elasticOutCurve = Curves.elasticOut;
  static const Curve bounceOutCurve = Curves.bounceOut;

  // 统一的颜色方案
  static const ColorScheme customColorScheme = ColorScheme(
    primary: Color(0xFF2196F3),      // 主蓝色
    secondary: Color(0xFF03DAC6),     // 青色
    surface: Color(0xFFFFFFFF),    // 背景灰白色
    error: Color(0xFFB00020),         // 错误红色
    onPrimary: Color(0xFFFFFFFF),     // 主色上的文字
    onSecondary: Color(0xFF000000),   // 次色上的文字
    onSurface: Color(0xFF000000),  // 背景上的文字
    onError: Color(0xFFFFFFFF),       // 错误色上的文字
    brightness: Brightness.light,     // 添加必需的 brightness 参数
  );

  // 闹钟类型专属颜色
  static const Map<String, Color> alarmTypeColors = {
    'WakeUp': Color(0xFFFF6B6B),    // 温暖的红色系
    'ClassBell': Color(0xFF4ECDC4),  // 清新的青色系
    'DrinkWater': Color(0xFF45B7D1), // 舒适的蓝色系
  };

  // 闹钟类型图标
  static const Map<String, IconData> alarmTypeIcons = {
    'WakeUp': Icons.bedtime,
    'ClassBell': Icons.school,
    'DrinkWater': Icons.water_drop,
  };

  // 闹钟类型显示名称
  static const Map<String, String> alarmTypeDisplayNames = {
    'WakeUp': '起床闹钟',
    'ClassBell': '上课铃',
    'DrinkWater': '喝水提醒',
  };

  // 统一的动画时长
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);

  // 统一的圆角半径
  static const double smallBorderRadius = 8.0;
  static const double mediumBorderRadius = 12.0;
  static const double largeBorderRadius = 16.0;

  // 统一的间距
  static const double tinyPadding = 4.0;
  static const double smallPadding = 8.0;
  static const double mediumPadding = 16.0;
  static const double largePadding = 24.0;

  // 统一的阴影
  static const List<BoxShadow> lightShadow = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  // 统一的卡片样式
  static BoxDecoration standardCardDecoration({
    Color? borderColor,
    Color? backgroundColor,
    double borderRadius = largeBorderRadius,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? Colors.white,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor ?? Colors.grey.withAlpha(30),
        width: 1,
      ),
      boxShadow: shadows ?? lightShadow,
    );
  }

  // 渐变背景样式
  static LinearGradient alarmTypeGradient(String alarmType) {
    final color = alarmTypeColors[alarmType] ?? alarmTypeColors['WakeUp']!;
    return LinearGradient(
      colors: [
        color.withAlpha(20),
        Colors.transparent,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // 获取闹钟类型颜色
  static Color getAlarmTypeColor(String alarmType) {
    return alarmTypeColors[alarmType] ?? alarmTypeColors['WakeUp']!;
  }

  // 获取闹钟类型图标
  static IconData getAlarmTypeIcon(String alarmType) {
    return alarmTypeIcons[alarmType] ?? alarmTypeIcons['WakeUp']!;
  }

  // 获取闹钟类型显示名称
  static String getAlarmTypeDisplayName(String alarmType) {
    return alarmTypeDisplayNames[alarmType] ?? alarmTypeDisplayNames['WakeUp']!;
  }

  // 统一的标题样式
  static const TextStyle cardTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xFF333333),
  );

  static const TextStyle sectionTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF666666),
  );

  // 统一的正文样式
  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF666666),
    height: 1.5,
  );

  static const TextStyle captionTextStyle = TextStyle(
    fontSize: 12,
    color: Color(0xFF999999),
  );

  // 统一的按钮样式
  static ButtonStyle primaryButtonStyle(Color primaryColor) {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(mediumBorderRadius),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: mediumPadding,
        vertical: smallPadding,
      ),
    );
  }

  static ButtonStyle secondaryButtonStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: customColorScheme.primary,
      side: BorderSide(color: customColorScheme.primary.withAlpha(100)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(mediumBorderRadius),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: mediumPadding,
        vertical: smallPadding,
      ),
    );
  }
}