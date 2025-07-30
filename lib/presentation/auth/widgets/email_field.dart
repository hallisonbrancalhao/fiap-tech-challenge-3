import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
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
}
