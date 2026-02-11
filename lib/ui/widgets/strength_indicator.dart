import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StrengthIndicator extends StatelessWidget {
  final double strength; // Expected 0.0 .. 1.0

  const StrengthIndicator({super.key, required this.strength});

  @override
  Widget build(BuildContext context) {
    final safeStrength = (strength.isFinite && strength >= 0 && strength <= 1)
        ? strength
        : 0.0;

    Color color;
    String label;

    if (safeStrength < 0.3) {
      color = Colors.redAccent;
      label = 'Weak';
    } else if (safeStrength < 0.6) {
      color = Colors.orangeAccent;
      label = 'Fair';
    } else if (safeStrength < 0.8) {
      color = Colors.blueAccent;
      label = 'Strong';
    } else {
      color = Colors.greenAccent;
      label = 'Excellent';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Strength Label
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Strength',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ).animate(key: ValueKey(label)).fadeIn().scale(),
          ],
        ),
        const SizedBox(height: 8),
        // Strength Bar
        Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              height: 6,
              width: MediaQuery.of(context).size.width * safeStrength * 0.8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.5), color],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
