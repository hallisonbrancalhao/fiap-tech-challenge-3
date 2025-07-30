import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_challenge_3/common/widgets/dialogs/base_dialog.dart';
import 'package:tech_challenge_3/presentation/auth/bloc/pin_cubit.dart';
import 'package:tech_challenge_3/presentation/auth/bloc/pin_state.dart';
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
  final GlobalKey _pinInputKey = GlobalKey();
  int _failedAttempts = 0;
  static const int _maxAttempts = 3;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PinCubit(),
      child: BlocListener<PinCubit, PinState>(
        listener: (context, state) {
          if (state is PinValidated) {
            Navigator.of(context).pop();
            widget.onPinValidated('');
          } else if (state is PinValidationFailed) {
            setState(() {
              _failedAttempts++;
            });

            if (_failedAttempts >= _maxAttempts) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Muitas tentativas incorretas. Faça login novamente.',
                  ),
                ),
              );
            } else {
              if (_pinInputKey.currentState != null) {
                (_pinInputKey.currentState as dynamic).resetPin();
              }
            }
          } else if (state is PinError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        child: BlocBuilder<PinCubit, PinState>(
          builder: (context, state) {
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
                      context.read<PinCubit>().validatePin(pin);
                    },
                  ),
                  if (state is PinLoading) ...[
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(),
                  ],
                  if (state is PinValidationFailed) ...[
                    const SizedBox(height: 8),
                    Text(
                      'PIN incorreto. Tentativas restantes: ${_maxAttempts - _failedAttempts}',
                      style: const TextStyle(color: Colors.red),
                    ),
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
          },
        ),
      ),
    );
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
