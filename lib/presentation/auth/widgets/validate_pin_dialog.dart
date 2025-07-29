import 'package:flutter/material.dart';
import 'package:tech_challenge_3/common/widgets/dialogs/base_dialog.dart';
import 'package:tech_challenge_3/presentation/auth/widgets/pin_input.dart';

class ValidatePinDialog extends StatefulWidget {
  final Function(String) onPinValidated;
  final Function()? onCancel;
  final Function()? onForgotPin;

  const ValidatePinDialog({
    super.key,
    required this.onPinValidated,
    this.onCancel,
    this.onForgotPin,
  });

  @override
  State<ValidatePinDialog> createState() => _ValidatePinDialogState();
}

class _ValidatePinDialogState extends State<ValidatePinDialog> {
  String? errorText;
  int failedAttempts = 0;
  final GlobalKey _pinInputKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'Digite seu PIN de segurança',
      barrierDismissible: false,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Para sua segurança, confirme sua identidade.'),
          const SizedBox(height: 16),
          PinInput(
            key: _pinInputKey,
            onCompleted: (pin) {
              final isValid = _validatePin(pin);
              if (isValid) {
                widget.onPinValidated(pin);
              } else {
                setState(() {
                  failedAttempts++;

                  final formatError = _validatePinFormat(pin);
                  if (formatError != null) {
                    errorText = formatError;
                  } else if (failedAttempts >= 3) {
                    errorText =
                        'Muitas tentativas incorretas. Faça login novamente.';
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.of(context).pop();
                    });
                  } else {
                    errorText =
                        'PIN incorreto. Tentativas restantes: ${3 - failedAttempts}';
                  }
                });

                if (_pinInputKey.currentState != null) {
                  (_pinInputKey.currentState as dynamic).resetPin();
                }
              }
            },
          ),
          if (errorText != null) ...[
            const SizedBox(height: 8),
            Text(errorText!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 16),
          Column(
            children: [
              if (widget.onCancel != null)
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: widget.onCancel,
                    child: const Text('Cancelar'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  bool _validatePin(String pin) {
    final formatValidation = _validatePinFormat(pin);
    if (formatValidation != null) {
      return false;
    }

    return pin == '5678';
  }

  String? _validatePinFormat(String pin) {
    if (pin.length != 4) {
      return 'PIN deve ter exatamente 4 dígitos';
    }
    if (!RegExp(r'^[0-9]{4}').hasMatch(pin)) {
      return 'PIN deve conter apenas números';
    }
    return null;
  }

  static Future<void> show({
    required BuildContext context,
    required Function(String) onPinValidated,
    Function()? onCancel,
    Function()? onForgotPin,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => ValidatePinDialog(
            onPinValidated: onPinValidated,
            onCancel: onCancel,
            onForgotPin: onForgotPin,
          ),
    );
  }
}
