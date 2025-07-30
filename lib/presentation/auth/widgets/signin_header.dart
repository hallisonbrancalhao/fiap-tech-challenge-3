import 'package:flutter/material.dart';

class SigninHeader extends StatelessWidget {
  const SigninHeader({super.key});

  @override
  Widget build(BuildContext context) {
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
}
