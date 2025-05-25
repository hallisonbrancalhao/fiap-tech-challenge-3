import 'package:flutter/material.dart';

class TransactionTypeDropdown extends StatefulWidget {
  const TransactionTypeDropdown({super.key});

  @override
  State<TransactionTypeDropdown> createState() =>
      _TransactionTypeDropdownState();
}

class _TransactionTypeDropdownState extends State<TransactionTypeDropdown> {
  final List<String> transactionTypes = ['Saque', 'Depósito', 'Transferencia'];
  String? transactionType;

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Esse campo é obrigatório';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de transação',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.0),
        DropdownButtonFormField<String>(
          items:
              transactionTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
          decoration: InputDecoration(
            hintText: 'Selecione o tipo de transação',
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: OutlineInputBorder(),
          ),
          validator: _validator,
          onChanged: (String? value) {
            transactionType = value;
          },
        ),
      ],
    );
  }
}
