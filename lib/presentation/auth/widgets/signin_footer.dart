import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tech_challenge_3/presentation/auth/pages/signup.dart';

class SigninFooter extends StatelessWidget {
  final VoidCallback onForgotPin;

  const SigninFooter({super.key, required this.onForgotPin});

  @override
  Widget build(BuildContext context) {
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
                recognizer: TapGestureRecognizer()..onTap = onForgotPin,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
