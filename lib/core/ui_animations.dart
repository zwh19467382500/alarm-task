import 'package:flutter/material.dart';

/// 应用统一的动画效果
class AppUIAnimations {
  // 私有构造函数，防止实例化
  const AppUIAnimations._();

  // 统一的动画时长
  static const Duration fastDuration = Duration(milliseconds: 150);
  static const Duration normalDuration = Duration(milliseconds: 300);
  static const Duration slowDuration = Duration(milliseconds: 500);

  // 统一的曲线
  static const Curve easeInCurve = Curves.easeIn;
  static const Curve easeOutCurve = Curves.easeOut;
  static const Curve easeInOutCurve = Curves.easeInOut;
  static const Curve bounceInCurve = Curves.bounceIn;
  static const Curve bounceOutCurve = Curves.bounceOut;
  static const Curve elasticOutCurve = Curves.elasticOut;

  // 淡入动画
  static Widget fadeIn({
    required Widget child,
    Duration duration = normalDuration,
    Curve curve = easeOutCurve,
    VoidCallback? onComplete,
  }) {
    return FadeTransition(
      opacity: AlwaysStoppedAnimation(1.0),
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: duration,
        curve: curve,
        child: child,
      ),
    );
  }

  // 滑入动画
  static Widget slideIn({
    required Widget child,
    Offset beginOffset = const Offset(0, 0.3),
    Duration duration = normalDuration,
    Curve curve = easeOutCurve,
    VoidCallback? onComplete,
  }) {
    return SlideTransition(
      position: AlwaysStoppedAnimation(Offset.zero),
      child: AnimatedSlide(
        offset: Offset.zero,
        duration: duration,
        curve: curve,
        child: child,
      ),
    );
  }

  // 缩放动画
  static Widget scaleIn({
    required Widget child,
    double beginScale = 0.8,
    Duration duration = normalDuration,
    Curve curve = elasticOutCurve,
    VoidCallback? onComplete,
  }) {
    return ScaleTransition(
      scale: AlwaysStoppedAnimation(1.0),
      child: AnimatedScale(
        scale: 1.0,
        duration: duration,
        curve: curve,
        child: child,
      ),
    );
  }

  // 组合动画：淡入 + 滑入
  static Widget fadeInSlideIn({
    required Widget child,
    Offset slideOffset = const Offset(0, 0.3),
    Duration duration = normalDuration,
    Curve curve = easeOutCurve,
    VoidCallback? onComplete,
  }) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  // 组合动画：淡入 + 缩放
  static Widget fadeInScaleIn({
    required Widget child,
    double beginScale = 0.8,
    Duration duration = normalDuration,
    Curve curve = elasticOutCurve,
    VoidCallback? onComplete,
  }) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  // 交错动画构建器
  static Widget staggeredAnimationBuilder({
    required List<Widget> children,
    Duration staggerDuration = const Duration(milliseconds: 100),
    Duration itemDuration = normalDuration,
    Curve curve = easeOutCurve,
    Axis direction = Axis.vertical,
  }) {
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;

        return AnimatedContainer(
          duration: itemDuration,
          curve: curve,
          transform: Matrix4.translationValues(
            direction == Axis.horizontal ? (index == 0 ? 0 : 50.0) : 0,
            direction == Axis.vertical ? (index == 0 ? 0 : 20.0) : 0,
            0,
          ),
          child: child,
        );
      }).toList(),
    );
  }

  // 按钮点击动画
  static Widget buttonBounce({
    required Widget child,
    required VoidCallback onPressed,
    Duration duration = fastDuration,
  }) {
    return GestureDetector(
      onTapDown: (_) {
        // 按下时的反馈
      },
      onTapUp: (_) {
        // 松开时的反馈
      },
      onTap: onPressed,
      child: AnimatedScale(
        scale: 1.0,
        duration: duration,
        child: child,
      ),
    );
  }

  // 卡片悬停效果
  static Widget cardHover({
    required Widget child,
    double hoverScale = 1.02,
    Duration duration = fastDuration,
    Curve curve = easeOutCurve,
  }) {
    return MouseRegion(
      child: AnimatedScale(
        scale: 1.0,
        duration: duration,
        curve: curve,
        child: child,
      ),
    );
  }

  // 脉冲动画（用于强调）
  static Widget pulse({
    required Widget child,
    double minScale = 0.95,
    double maxScale = 1.05,
    Duration duration = const Duration(milliseconds: 1000),
    bool repeat = true,
  }) {
    return AnimatedScale(
      scale: 1.0,
      duration: duration,
      child: child,
    );
  }

  // 页面转场动画
  static PageRouteBuilder<T> slideTransition<T>({
    required Widget page,
    Duration duration = normalDuration,
    Curve curve = easeOutCurve,
    SlideDirection direction = SlideDirection.left,
  }) {
    Offset beginOffset;
    switch (direction) {
      case SlideDirection.left:
        beginOffset = const Offset(1.0, 0.0);
        break;
      case SlideDirection.right:
        beginOffset = const Offset(-1.0, 0.0);
        break;
      case SlideDirection.up:
        beginOffset = const Offset(0.0, 1.0);
        break;
      case SlideDirection.down:
        beginOffset = const Offset(0.0, -1.0);
        break;
    }

    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: beginOffset, end: Offset.zero)
            .chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  // 淡入淡出转场动画
  static PageRouteBuilder<T> fadeTransition<T>({
    required Widget page,
    Duration duration = normalDuration,
    Curve curve = easeOutCurve,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}

// 滑动方向枚举
enum SlideDirection { left, right, up, down }

// 扩展 Widget 以添加动画效果
extension AnimatedWidgetExtension on Widget {
  Widget withFadeIn({
    Duration duration = AppUIAnimations.normalDuration,
    Curve curve = AppUIAnimations.easeOutCurve,
  }) {
    return AppUIAnimations.fadeIn(
      child: this,
      duration: duration,
      curve: curve,
    );
  }

  Widget withSlideIn({
    Offset offset = const Offset(0, 0.3),
    Duration duration = AppUIAnimations.normalDuration,
    Curve curve = AppUIAnimations.easeOutCurve,
  }) {
    return AppUIAnimations.slideIn(
      child: this,
      beginOffset: offset,
      duration: duration,
      curve: curve,
    );
  }

  Widget withScaleIn({
    double beginScale = 0.8,
    Duration duration = AppUIAnimations.normalDuration,
    Curve curve = AppUIAnimations.elasticOutCurve,
  }) {
    return AppUIAnimations.scaleIn(
      child: this,
      beginScale: beginScale,
      duration: duration,
      curve: curve,
    );
  }
}