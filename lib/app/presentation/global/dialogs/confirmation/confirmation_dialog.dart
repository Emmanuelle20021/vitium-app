import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.content,
    required this.onConfirm,
    this.onCancel,
  });

  final Widget content;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Estas seguro?'),
      content: content,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            onCancel!();
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}
