import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_challenge_3/common/bloc/button/button_state.dart';
import 'package:tech_challenge_3/common/bloc/button/button_state_cubit.dart';
import 'package:tech_challenge_3/common/widgets/button/basic_app_button.dart';
import 'package:tech_challenge_3/data/models/signup_req_params.dart';
import 'package:tech_challenge_3/domain/usecases/signup.dart';
import 'package:tech_challenge_3/presentation/auth/pages/custom_signin.dart';
import 'package:tech_challenge_3/presentation/home/pages/home.dart';
import 'package:tech_challenge_3/service_locator.dart';

class CustomSignupPage extends StatefulWidget {
  const CustomSignupPage({super.key});

  @override
  State<CustomSignupPage> createState() => _CustomSignupPageState();
}

class _CustomSignupPageState extends State<CustomSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCon = TextEditingController();
  final _emailCon = TextEditingController();
  final _passwordCon = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameCon.dispose();
    _emailCon.dispose();
    _passwordCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonSuccessState) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else if (state is ButtonFailureState) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    Image.asset('assets/images/image_login.png', height: 160),
                    const SizedBox(height: 32),
                    const Text(
                      'Criar conta',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _usernameCon,
                      decoration: const InputDecoration(
                        labelText: 'Nome de usuário',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor insira seu nome de usuário';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
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
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordCon,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
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
                          return 'Por favor insira uma senha';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    Builder(
                      builder: (context) {
                        return BasicAppButton(
                          title: 'Criar conta',
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          shadowColor: Colors.red,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<ButtonStateCubit>().excute(
                                usecase: sl<SignupUseCase>(),
                                params: SignupReqParams(
                                  username: _usernameCon.text,
                                  email: _emailCon.text,
                                  password: _passwordCon.text,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CustomSigninPage()),
                        );
                      },
                      child: const Text(
                        'Já tem uma conta? Entrar',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
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
}
