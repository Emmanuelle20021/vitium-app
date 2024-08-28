import 'package:flutter/material.dart';
import 'package:vitium/constants/constants.dart' as constants;

class RectangleButton extends StatelessWidget {
  const RectangleButton({
    super.key,
    required this.onPressed,
    this.accentColor = false,
    this.child,
  });

  final void Function()? onPressed;
  final bool accentColor;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor:
          accentColor ? constants.kSecondaryColor : constants.kTercearyColor,
      foregroundColor: Colors.white,
      child: child,
    );
  }
}
