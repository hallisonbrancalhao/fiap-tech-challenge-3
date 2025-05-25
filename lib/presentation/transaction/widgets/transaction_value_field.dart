import 'package:flutter/material.dart';

import 'package:tech_challenge_3/utils/currency_formatter.dart';

class TransactionValueField extends StatefulWidget {
  const TransactionValueField({super.key});

  @override
  State<TransactionValueField> createState() => _TransactionValueFieldState();
}

class _TransactionValueFieldState extends State<TransactionValueField> {
  final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter();

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Esse campo é obrigatório';
    }

    if (_currencyFormatter.getDouble() <= 0) {
      return 'O valor deve ser maior que 0,00';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Valor',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.0),
        TextFormField(
          decoration: InputDecoration(
            hintText: '0,00',
            border: OutlineInputBorder(),
          ),
          inputFormatters: [_currencyFormatter],
          keyboardType: TextInputType.number,
          validator: _validator,
        ),
      ],
    );
  }
}
