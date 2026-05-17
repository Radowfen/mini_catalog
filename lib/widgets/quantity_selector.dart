import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// −  N  +  şeklinde adet seçici.
class QuantitySelector extends StatelessWidget {
  final int value;
  final int min;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;
  final bool compact;

  const QuantitySelector({
    super.key,
    required this.value,
    this.min = 1,
    this.onDecrement,
    this.onIncrement,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final btnSize = compact ? 28.0 : 36.0;
    final iconSize = compact ? 16.0 : 20.0;
    final fontSize = compact ? 13.0 : 16.0;
    final canDecrement = value > min && onDecrement != null;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 4 : 6, vertical: 4),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(compact ? 10 : 14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RoundButton(
            size: btnSize,
            iconSize: iconSize,
            icon: Icons.remove_rounded,
            enabled: canDecrement,
            onTap: canDecrement ? onDecrement : null,
            color: c,
          ),
          SizedBox(
            width: compact ? 28 : 36,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: c.primary,
              ),
            ),
          ),
          _RoundButton(
            size: btnSize,
            iconSize: iconSize,
            icon: Icons.add_rounded,
            enabled: onIncrement != null,
            onTap: onIncrement,
            color: c,
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final double size;
  final double iconSize;
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;
  final AppColors color;

  const _RoundButton({
    required this.size,
    required this.iconSize,
    required this.icon,
    required this.enabled,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: enabled ? color.primary : color.divider,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: enabled ? color.onPrimary : color.secondary,
        ),
      ),
    );
  }
}
