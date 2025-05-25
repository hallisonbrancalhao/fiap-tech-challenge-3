import 'package:flutter/material.dart';

import 'package:tech_challenge_3/presentation/transaction/widgets/transaction_form.dart';

class UpdateTransaction extends StatelessWidget {
  const UpdateTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova transação')),
      extendBody: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
        child: TransactionForm(),
      ),
    );
  }
}
