import 'package:flutter/material.dart';
import 'package:vitium/constants/constants.dart' as constants;

class UnderlineInput extends StatelessWidget {
  const UnderlineInput({
    super.key,
    required this.icon,
    required this.hintText,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
  });
  final IconData icon;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String? email)? validator;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: constants.kLetterColor,
          size: 20,
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
