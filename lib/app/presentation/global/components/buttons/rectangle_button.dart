import 'package:flutter/material.dart';
import 'package:vitium/app/data/utils/constants/constants.dart' as constants;

class RectangleButton extends StatelessWidget {
  const RectangleButton({
    super.key,
    required this.onPressed,
    this.accentColor = false,
    this.child,
    this.tooltip,
    this.color,
  });

  final void Function()? onPressed;
  final bool accentColor;
  final Widget? child;
  final String? tooltip;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: color ??
          (accentColor ? constants.kSecondaryColor : constants.kTercearyColor),
      foregroundColor: Colors.white,
      tooltip: tooltip,
      child: child,
    );
  }
}
