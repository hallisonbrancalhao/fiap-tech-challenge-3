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
import 'package:tech_challenge_3/presentation/home/pages/home.dart';
import 'package:tech_challenge_3/service_locator.dart';
import 'package:tech_challenge_3/ui/auth/signin/bloc/signin_bloc.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
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
        create: (context) => SignInBloc(),
        child: BlocListener<SignInBloc, SignInState>(
          listener: (context, state) {
            // if (state is ButtonSuccessState) {
            //   Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(builder: (context) => const HomePage()),
            //   );
            // }
            // if (state is ButtonFailureState) {
            //   var snackBar = SnackBar(content: Text(state.errorMessage));
            //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
            // }
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
                    _EmailField(),
                    const SizedBox(height: 20),
                    _PasswordField(),
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

  Widget _createAccountButton(BuildContext context) {
    return Builder(
      builder: (context) {
        return BasicAppButton(
          title: 'Entrar',
          backgroundColor: AppTheme.appTheme.primaryColor,
          textColor: Colors.white,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // context.read<ButtonStateCubit>().excute(
              //   usecase: sl<SigninUseCase>(),
              //   params: SigninReqParams(
              //     email: _emailCon.text,
              //     password: _passwordCon.text,
              //   ),
              // );
              context.read<SignInBloc>().add(const SignInSubmit());
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
}

class _EmailField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // controller: _emailCon,
      decoration: const InputDecoration(
        labelText: 'E-mail',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        context.read<SignInBloc>().add(EmailChanged(email: value));
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor insira seu e-mail';
        }
        return null;
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // controller: _passwordCon,
      // obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Senha',
        border: const OutlineInputBorder(),
        // suffixIcon: IconButton(
        //   icon: Icon(
        //     _obscurePassword ? Icons.visibility_off : Icons.visibility,
        //   ),
        //   onPressed: () {
        //     setState(() {
        //       _obscurePassword = !_obscurePassword;
        //     });
        //   },
        // ),
      ),
      onChanged: (value) {
        context.read<SignInBloc>().add(PasswordChanged(password: value));
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor insira sua senha';
        }
        return null;
      },
    );
  }
}
