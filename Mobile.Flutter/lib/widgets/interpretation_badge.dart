import 'package:flutter/material.dart';
import '../config/theme.dart';

class InterpretationBadge extends StatelessWidget {
  final String? interpretation;
  final double fontSize;

  const InterpretationBadge({
    super.key,
    required this.interpretation,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final label = (interpretation == null || interpretation!.isEmpty)
        ? 'Not yet taken'
        : interpretation!;
    final color = AppTheme.interpretationColor(interpretation);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
