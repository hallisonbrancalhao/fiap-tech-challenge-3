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
              // TODO: remove comment to add the pin validation to success signin
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
    return Text.rich(
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
    );
  }

  // Verificar PIN e navegar
  Future<void> _checkPinAndNavigate(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString('user_pin');
    final hasPin = savedPin != null;

    // Debug: Verificar se PIN existe
    print('=== DEBUG PIN VALIDATION ===');
    print('Saved PIN: $savedPin');
    print('Has PIN: $hasPin');
    print('============================');

    // Sempre mostrar dialog de PIN
    print('Mostrando dialog de validação de PIN');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => ValidatePinDialog(
            onPinValidated: (pin) {
              print('PIN validado com sucesso: $pin');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            onCancel: () {
              // Voltar para tela de login
              print('Usuário cancelou validação de PIN');
              Navigator.pop(context);
            },
            onForgotPin: () {
              // Implementar reset de PIN
              print('Usuário esqueceu PIN');
              Navigator.pop(context);
              _showForgotPinDialog(context);
            },
          ),
    );
  }

  // Dialog para "Esqueci meu PIN"
  void _showForgotPinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Redefinir PIN'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Como você gostaria de redefinir seu PIN?'),
                SizedBox(height: 16),
                Text('• Email: Receber código por email'),
                Text('• Novo PIN: Configurar um novo PIN'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showEmailResetDialog(context);
                },
                child: const Text('Por Email'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showNewPinDialog(context);
                },
                child: const Text('Novo PIN'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ],
          ),
    );
  }

  // Dialog para reset por email
  void _showEmailResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Reset por Email'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Um código será enviado para seu email.'),
                SizedBox(height: 8),
                Text(
                  'Use o código: 1234',
                  style: TextStyle(fontWeight: FontWeight.bold),
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

  // Dialog para inserir código do email
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
                              errorText = 'Código incorreto. Use: 1234';
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

  // Dialog para configurar novo PIN
  void _showNewPinDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => CreatePinDialog(
            onPinCreated: (pin) async {
              // Salvar novo PIN
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('user_pin', pin);
              await prefs.setString(
                'pin_created_at',
                DateTime.now().toIso8601String(),
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
    );
  }
}
