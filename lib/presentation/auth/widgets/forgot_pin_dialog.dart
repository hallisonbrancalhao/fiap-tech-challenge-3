import 'package:flutter/material.dart';

class ForgotPinDialog extends StatelessWidget {
  final TextEditingController emailController;
  final VoidCallback onContinue;
  final VoidCallback onCancel;

  const ForgotPinDialog({
    super.key,
    required this.emailController,
    required this.onContinue,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Redefinir PIN'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Digite seu email para receber um código de redefinição:'),
          const SizedBox(height: 16),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 8),
          const Text('Um código será enviado para seu email.'),
        ],
      ),
      actions: [
        TextButton(onPressed: onContinue, child: const Text('Continuar')),
        TextButton(onPressed: onCancel, child: const Text('Cancelar')),
      ],
    );
  }
}
