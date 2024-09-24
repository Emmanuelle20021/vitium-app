import 'package:flutter/material.dart';

class AplicationNameTag extends StatelessWidget {
  const AplicationNameTag({
    super.key,
    this.withLogo = false,
  });

  final bool withLogo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          withLogo ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (withLogo)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
            child: Image.asset('assets/images/vitium_logo.png'),
          ),
        const Text(
          'VITIUM',
          style: TextStyle(color: Colors.blue),
        ),
      ],
    );
  }
}
