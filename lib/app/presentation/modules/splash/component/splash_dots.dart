import 'package:flutter/material.dart';
import 'package:vitium/app/data/utils/constants/constants.dart';

class SplashDots extends StatelessWidget {
  final int currentIndex;
  final int length;

  const SplashDots(
      {super.key, required this.currentIndex, required this.length});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        length,
        (index) => buildDot(index: index),
      ),
    );
  }

  Widget buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentIndex == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentIndex == index ? kPrimaryColor : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
