import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_challenge_3/common/widgets/dialogs/base_dialog.dart';
import 'package:tech_challenge_3/presentation/auth/widgets/pin_input.dart';

class CreatePinDialog extends StatefulWidget {
  final Function(String) onPinCreated;
  final Function()? onCancel;

  const CreatePinDialog({super.key, required this.onPinCreated, this.onCancel});

  @override
  State<CreatePinDialog> createState() => _CreatePinDialogState();
}

class _CreatePinDialogState extends State<CreatePinDialog> {
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'Crie seu PIN de 4 dígitos',
      barrierDismissible: false,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Este PIN será usado como segundo fator de autenticação.'),
          const SizedBox(height: 16),
          PinInput(
            onCompleted: (pin) async {
              final validation = _validatePin(pin);
              if (validation == null) {
                await _savePinToLocalStorage(pin);

                widget.onPinCreated(pin);
              } else {
                setState(() {
                  errorText = validation;
                });
              }
            },
          ),
          if (errorText != null) ...[
            const SizedBox(height: 8),
            Text(errorText!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 8),
          const Text(
            'Dica: Use 1234 para testes.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        if (widget.onCancel != null)
          TextButton(onPressed: widget.onCancel, child: const Text('Cancelar')),
      ],
    );
  }

  String? _validatePin(String pin) {
    if (pin.length != 4) {
      return 'PIN deve ter exatamente 4 dígitos';
    }
    if (!RegExp(r'^[0-9]{4}').hasMatch(pin)) {
      return 'PIN deve conter apenas números';
    }
    return null;
  }

  Future<void> _savePinToLocalStorage(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_pin', pin);
    await prefs.setString('pin_created_at', DateTime.now().toIso8601String());
  }

  static Future<void> show({
    required BuildContext context,
    required Function(String) onPinCreated,
    Function()? onCancel,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) =>
              CreatePinDialog(onPinCreated: onPinCreated, onCancel: onCancel),
    );
  }
}
