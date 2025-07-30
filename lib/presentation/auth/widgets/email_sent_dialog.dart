import 'package:flutter/material.dart';

class EmailSentDialog extends StatelessWidget {
  final VoidCallback onOk;

  const EmailSentDialog({super.key, required this.onOk});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Código enviado'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Um código foi enviado para seu email.'),
          SizedBox(height: 8),
          Text('Verifique sua caixa de entrada e digite o código recebido.'),
        ],
      ),
      actions: [TextButton(onPressed: onOk, child: const Text('OK'))],
    );
  }
}
