import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_challenge_3/common/widgets/dialogs/base_dialog.dart';
import 'package:tech_challenge_3/presentation/auth/bloc/pin_cubit.dart';
import 'package:tech_challenge_3/presentation/auth/bloc/pin_state.dart';
import 'package:tech_challenge_3/presentation/auth/widgets/pin_input.dart';

class CreatePinDialog extends StatelessWidget {
  final Function(String) onPinCreated;
  final Function()? onCancel;

  const CreatePinDialog({super.key, required this.onPinCreated, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PinCubit(),
      child: BlocListener<PinCubit, PinState>(
        listener: (context, state) {
          if (state is PinCreated) {
            Navigator.of(context).pop();
            onPinCreated('');
          } else if (state is PinError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        child: BlocBuilder<PinCubit, PinState>(
          builder: (context, state) {
            return BaseDialog(
              title: 'Crie seu PIN de 4 dígitos',
              barrierDismissible: false,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Este PIN será usado como segundo fator de autenticação.',
                  ),
                  const SizedBox(height: 16),
                  PinInput(
                    onCompleted: (pin) {
                      context.read<PinCubit>().createPin(pin);
                    },
                  ),
                  if (state is PinLoading) ...[
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(),
                  ],
                  const SizedBox(height: 8),
                ],
              ),
              actions: [
                if (onCancel != null)
                  TextButton(
                    onPressed: onCancel,
                    child: const Text('Cancelar'),
                  ),
              ],
            );
          },
        ),
      ),
    );
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
