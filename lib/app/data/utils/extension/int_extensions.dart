import 'package:flutter/material.dart';

extension IntToGap on int {
  Widget get toVerticalGap => SizedBox(height: toDouble());
  Widget get toHorizontalGap => SizedBox(width: toDouble());
}
