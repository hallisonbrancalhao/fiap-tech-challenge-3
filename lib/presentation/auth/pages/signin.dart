import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_challenge_3/common/bloc/button/button_state.dart';
import 'package:tech_challenge_3/common/bloc/button/button_state_cubit.dart';
import 'package:tech_challenge_3/common/widgets/button/basic_app_button.dart';
import 'package:tech_challenge_3/core/configs/theme/app_theme.dart';
import 'package:tech_challenge_3/data/models/signin_req_params.dart';
import 'package:tech_challenge_3/domain/usecases/auth/signin.dart';
import 'package:tech_challenge_3/presentation/auth/widgets/validate_pin_dialog.dart';
import 'package:tech_challenge_3/presentation/auth/widgets/create_pin_dialog.dart';
import 'package:tech_challenge_3/presentation/auth/widgets/signin_header.dart';
import 'package:tech_challenge_3/presentation/auth/widgets/email_field.dart';
import 'package:tech_challenge_3/presentation/auth/widgets/password_field.dart';
import 'package:tech_challenge_3/presentation/auth/widgets/signin_footer.dart';
import 'package:tech_challenge_3/presentation/auth/widgets/forgot_pin_dialog.dart';
import 'package:tech_challenge_3/presentation/auth/widgets/email_sent_dialog.dart';
import 'package:tech_challenge_3/presentation/auth/widgets/email_code_dialog.dart';
import 'package:tech_challenge_3/presentation/home/pages/home.dart';
import 'package:tech_challenge_3/service_locator.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCon = TextEditingController();
  final _passwordCon = TextEditingController();

  @override
  void dispose() {
    _emailCon.dispose();
    _passwordCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonSuccessState) {
              _checkPinAndNavigate(context);
            }
            if (state is ButtonFailureState) {
              var snackBar = SnackBar(content: Text(state.errorMessage));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          child: SafeArea(
            minimum: const EdgeInsets.only(top: 30, right: 16, left: 16),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SigninHeader(),
                    const SizedBox(height: 50),
                    EmailField(controller: _emailCon),
                    const SizedBox(height: 20),
                    PasswordField(controller: _passwordCon),
                    const SizedBox(height: 40),
                    _createAccountButton(context),
                    const SizedBox(height: 20),
                    SigninFooter(
                      onForgotPin: () => _showForgotPinDialog(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createAccountButton(BuildContext context) {
    return Builder(
      builder: (context) {
        return BasicAppButton(
          title: 'Entrar',
          backgroundColor: AppTheme.appTheme.primaryColor,
          textColor: Colors.white,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<ButtonStateCubit>().excute(
                usecase: sl<SigninUseCase>(),
                params: SigninReqParams(
                  email: _emailCon.text,
                  password: _passwordCon.text,
                ),
              );
            } else {
              var snackBar = const SnackBar(
                content: Text(
                  'Por favor, preencha todos os campos corretamente.',
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
        );
      },
    );
  }

  Future<void> _checkPinAndNavigate(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => ValidatePinDialog(
            onPinValidated: (pin) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            onCancel: () {
              Navigator.pop(context);
            },
            onForgotPin: () {
              Navigator.pop(context);
              _showForgotPinDialog(context);
            },
          ),
    );
  }

  void _showForgotPinDialog(BuildContext context) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => ForgotPinDialog(
            emailController: emailController,
            onContinue: () {
              if (emailController.text.isNotEmpty) {
                Navigator.pop(context);
                _showEmailResetDialog(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor, digite um email válido'),
                  ),
                );
              }
            },
            onCancel: () => Navigator.pop(context),
          ),
    );
  }

  void _showEmailResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => EmailSentDialog(
            onOk: () {
              Navigator.pop(context);
              _showEmailCodeDialog(context);
            },
          ),
    );
  }

  void _showEmailCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => EmailCodeDialog(
            onCodeValid: () {
              Navigator.pop(context);
              _showNewPinDialog(context);
            },
            onCancel: () => Navigator.pop(context),
          ),
    );
  }

  void _showNewPinDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => CreatePinDialog(
            onPinCreated: (pin) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
    );
  }
}
