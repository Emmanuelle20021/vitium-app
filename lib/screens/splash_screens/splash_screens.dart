import 'package:flutter/material.dart';
import 'package:vitium/constants/constants.dart' as constants;
import 'package:vitium/screens/splash_screens/components/splash_dots.dart';

const int listLength = 3;

class SplashScreens extends StatefulWidget {
  const SplashScreens({super.key});

  @override
  State<SplashScreens> createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> {
  final PageController _controller = PageController(initialPage: 0);

  int _currentIndex = 0;

  final List<Widget> _pages = constants.splashPages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SplashDots(currentIndex: _currentIndex, length: _pages.length),
            Text(
              'Vitium',
              style: TextStyle(
                  color: constants.kVitiumNameColor,
                  fontFamily: 'Lato',
                  fontSize: 16),
            ),
          ],
        ),
      ),
      body: PageView(
        scrollDirection: Axis.horizontal,
        controller: _controller,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
    );
  }

  void _onPageChanged(int value) {
    setState(() {
      _currentIndex = value;
    });
  }
}
