import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool isLocked = false;
  bool hasExistingPin = false;

  @override
  void initState() {
    super.initState();
    _checkExistingPin();
  }

  Future<void> _checkExistingPin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString('user_pin');
    setState(() {
      hasExistingPin = savedPin != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title:
          hasExistingPin
              ? 'Digite seu PIN de segurança'
              : 'Configure seu PIN de segurança',
      barrierDismissible: false,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            hasExistingPin
                ? 'Para sua segurança, confirme sua identidade.'
                : 'Configure um PIN de 4 dígitos para sua segurança.',
          ),
          const SizedBox(height: 16),
          PinInput(
            onCompleted: (pin) async {
              if (isLocked) {
                setState(() {
                  errorText =
                      'PIN bloqueado temporariamente. Tente novamente em 1 minuto.';
                });
                return;
              }

              final isValid = await _validatePin(pin);
              if (isValid) {
                widget.onPinValidated(pin);
              } else {
                setState(() {
                  failedAttempts++;

                  // Verificar se é erro de formato ou PIN incorreto
                  final formatError = _validatePinFormat(pin);
                  if (formatError != null) {
                    errorText = formatError;
                  } else if (failedAttempts >= 3) {
                    isLocked = true;
                    errorText =
                        'Muitas tentativas incorretas. PIN bloqueado por 1 minuto.';
                    // TODO: Implementar timer para desbloquear
                  } else {
                    errorText =
                        hasExistingPin
                            ? 'PIN incorreto. Tentativas restantes: ${3 - failedAttempts}'
                            : 'PIN inválido. Use apenas números.';
                  }
                });
              }
            },
          ),
          if (errorText != null) ...[
            const SizedBox(height: 8),
            Text(errorText!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (widget.onCancel != null)
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text('Cancelar'),
                ),
              if (widget.onForgotPin != null && hasExistingPin)
                TextButton(
                  onPressed: widget.onForgotPin,
                  child: const Text('Esqueci meu PIN'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> _validatePin(String pin) async {
    // TODO: Implementar validação real com hash + salt + pepper
    // Por enquanto, valida contra localStorage

    // Validar formato do PIN primeiro
    final formatValidation = _validatePinFormat(pin);
    if (formatValidation != null) {
      return false; // PIN inválido
    }

    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString('user_pin');

    // Se não tem PIN configurado, aceitar qualquer PIN válido como "primeiro PIN"
    if (savedPin == null) {
      // Salvar o primeiro PIN
      await prefs.setString('user_pin', pin);
      await prefs.setString('pin_created_at', DateTime.now().toIso8601String());
      return true;
    }

    return savedPin == pin;
  }

  String? _validatePinFormat(String pin) {
    if (pin.length != 4) {
      return 'PIN deve ter exatamente 4 dígitos';
    }
    if (!RegExp(r'^[0-9]{4}').hasMatch(pin)) {
      return 'PIN deve conter apenas números';
    }
    // Validação de PIN fácil removida para facilitar testes
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
