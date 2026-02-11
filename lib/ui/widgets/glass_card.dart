import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer.frostedGlass(
      width: width ?? double.infinity,
      height: height ?? 500,
      padding: padding ?? const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(24),
      borderWidth: 1.5,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.2),
          Colors.white.withOpacity(0.1),
          Colors.purple.withOpacity(0.2),
          Colors.blue.withOpacity(0.2),
        ],
      ),
      blur: 15,
      child: child,
    );
  }
}
