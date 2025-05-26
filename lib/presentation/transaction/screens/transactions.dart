import 'package:flutter/material.dart';

import 'package:tech_challenge_3/presentation/transaction/widgets/transaction_list.dart';
import 'package:tech_challenge_3/presentation/transaction/widgets/transaction_list_filter.dart';

import 'package:tech_challenge_3/core/routes/app_routes.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transações'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.newTransaction);
            },
            child: Text('Nova transação'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 24, 12, 32),
              child: TransactionListFilter(),
            ),
            TransactionList(),
            SizedBox(height: 32),
            TransactionList(),
            SizedBox(height: 32),
            TransactionList(),
          ],
        ),
      ),
    );
  }
}
