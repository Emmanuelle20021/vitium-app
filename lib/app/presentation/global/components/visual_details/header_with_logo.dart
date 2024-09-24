import 'package:flutter/material.dart';

class HeaderWithLogo extends StatelessWidget {
  const HeaderWithLogo({
    super.key,
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Image.asset('assets/images/vitium_logo.png'),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 20),
        subtitle != null
            ? Text(
                subtitle!,
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
