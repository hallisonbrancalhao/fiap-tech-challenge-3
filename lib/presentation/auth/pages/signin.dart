import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_challenge_3/common/bloc/button/button_state.dart';
import 'package:tech_challenge_3/common/bloc/button/button_state_cubit.dart';
import 'package:tech_challenge_3/common/widgets/button/basic_app_button.dart';
import 'package:tech_challenge_3/core/configs/theme/app_theme.dart';
import 'package:tech_challenge_3/data/models/signin_req_params.dart';
import 'package:tech_challenge_3/domain/usecases/auth/signin.dart';
import 'package:tech_challenge_3/presentation/auth/pages/signup.dart';
import 'package:tech_challenge_3/presentation/auth/widgets/validate_pin_dialog.dart';
import 'package:tech_challenge_3/presentation/auth/widgets/create_pin_dialog.dart';
import 'package:tech_challenge_3/presentation/auth/widgets/pin_input.dart';
import 'package:tech_challenge_3/presentation/home/pages/home.dart';
import 'package:tech_challenge_3/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCon = TextEditingController();
  final _passwordCon = TextEditingController();
  bool _obscurePassword = true;

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
                    _signin(),
                    const SizedBox(height: 50),
                    _emailField(),
                    const SizedBox(height: 20),
                    _password(),
                    const SizedBox(height: 40),
                    _createAccountButton(context),
                    const SizedBox(height: 20),
                    _signupText(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _signin() {
    return Column(
      children: [
        Image.asset('assets/images/image_login.png', height: 160),
        const SizedBox(height: 32),
        const Text(
          'Entrar',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _emailField() {
    return TextFormField(
      controller: _emailCon,
      decoration: const InputDecoration(
        labelText: 'E-mail',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor insira seu e-mail';
        }
        return null;
      },
    );
  }

  Widget _password() {
    return TextFormField(
      controller: _passwordCon,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Senha',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor insira sua senha';
        }
        return null;
      },
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

  Widget _signupText(BuildContext context) {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: "Não tem uma conta? "),
              TextSpan(
                text: 'Criar conta',
                style: TextStyle(
                  color: Color(0xff3461FD),
                  fontWeight: FontWeight.w500,
                ),
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage()),
                        );
                      },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Esqueceu seu PIN?',
                style: TextStyle(
                  color: Color(0xff3B4054),
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: ' Redefinir',
                style: const TextStyle(
                  color: Color(0xff3461FD),
                  fontWeight: FontWeight.w500,
                ),
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () {
                        _showForgotPinDialog(context);
                      },
              ),
            ],
          ),
        ),
      ],
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
          (context) => AlertDialog(
            title: const Text('Redefinir PIN'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Digite seu email para receber um código de redefinição:',
                ),
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
              TextButton(
                onPressed: () {
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
                child: const Text('Continuar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ],
          ),
    );
  }

  void _showEmailResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Código enviado'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Um código foi enviado para seu email.'),
                SizedBox(height: 8),
                Text(
                  'Verifique sua caixa de entrada e digite o código recebido.',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showEmailCodeDialog(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showEmailCodeDialog(BuildContext context) {
    String? errorText;
    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
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
                            Navigator.pop(context);
                            _showNewPinDialog(context);
                          } else {
                            setState(() {
                              errorText = 'Código incorreto. Tente novamente.';
                            });
                          }
                        },
                      ),
                      if (errorText != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          errorText!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                  ],
                ),
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
