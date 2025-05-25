import 'package:flutter/material.dart';

import 'package:tech_challenge_3/presentation/transaction/widgets/transaction_list.dart';
import 'package:tech_challenge_3/presentation/transaction/widgets/transaction_list_filter.dart';

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
              Navigator.pushNamed(context, '/new-transaction');
            },
            child: Text('Nova transação'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TransactionListFilter(),
          ),
          TransactionList(),
        ],
      ),
    );
  }
}
