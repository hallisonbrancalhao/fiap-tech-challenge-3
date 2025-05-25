import 'package:flutter/material.dart';

import 'package:tech_challenge_3/presentation/transaction/widgets/transaction_type_dropdown.dart';
import 'package:tech_challenge_3/presentation/transaction/widgets/receipt_file_picker.dart';
import 'package:tech_challenge_3/presentation/transaction/widgets/transaction_value_field.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();

  void _createTransaction() {
    if (_formKey.currentState!.validate()) {
      print('criar transação');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TransactionTypeDropdown(),
          SizedBox(height: 24),
          TransactionValueField(),
          SizedBox(height: 24),
          ReceipFilePicker(),
          SizedBox(height: 48),
          FilledButton(
            onPressed: _createTransaction,
            child: const Text('Concluir transação'),
          ),
          SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}
