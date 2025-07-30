import 'package:flutter/material.dart';
import 'package:tech_challenge_3/presentation/auth/widgets/pin_input.dart';

class EmailCodeDialog extends StatefulWidget {
  final VoidCallback onCodeValid;
  final VoidCallback onCancel;

  const EmailCodeDialog({
    super.key,
    required this.onCodeValid,
    required this.onCancel,
  });

  @override
  State<EmailCodeDialog> createState() => _EmailCodeDialogState();
}

class _EmailCodeDialogState extends State<EmailCodeDialog> {
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder:
          (context, setState) => AlertDialog(
            title: const Text('Digite o código'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Digite o código enviado para seu email:'),
                const SizedBox(height: 16),
                PinInput(
                  onCompleted: (code) {
                    if (code == '1234') {
                      widget.onCodeValid();
                    } else {
                      setState(() {
                        errorText = 'Código incorreto. Tente novamente.';
                      });
                    }
                  },
                ),
                if (errorText != null) ...[
                  const SizedBox(height: 8),
                  Text(errorText!, style: const TextStyle(color: Colors.red)),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: widget.onCancel,
                child: const Text('Cancelar'),
              ),
            ],
          ),
    );
  }
}
