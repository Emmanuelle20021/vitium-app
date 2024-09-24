import 'package:flutter/material.dart';
import 'package:vitium/app/data/utils/constants/constants.dart' as constants;

class UnderlineInput extends StatelessWidget {
  const UnderlineInput({
    super.key,
    required this.icon,
    required this.hintText,
    this.controller,
    this.initialValue,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    this.label,
    this.maxLength,
  });
  final IconData icon;
  final String hintText;
  final TextEditingController? controller;
  final String? initialValue;
  final String? Function(String? email)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? label;
  final void Function(String)? onChanged;
  final int? maxLength;

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: TextFormField(
              controller: controller,
              initialValue: initialValue,
              keyboardType: keyboardType,
              validator: validator,
              maxLength: maxLength,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                label: label,
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.grey),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              obscureText: obscureText,
            ),
          ),
        ),
      ],
    );
  }
}
