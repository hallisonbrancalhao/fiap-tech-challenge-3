import 'package:flutter/material.dart';

import 'package:tech_challenge_3/presentation/transaction/widgets/transaction_list.dart';
import 'package:tech_challenge_3/presentation/transaction/widgets/transaction_list_filter.dart';

import 'package:tech_challenge_3/core/routes/app_routes.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  static List<dynamic> transactions = [
    {
      'id': 1,
      'type': 'depósito',
      'value': 6452,
      'createdAt': DateTime.now(),
      'userId': 1,
    },
    {
      'id': 1,
      'type': 'saque',
      'value': 235,
      'createdAt': DateTime.now(),
      'userId': 1,
    },
    {
      'id': 1,
      'type': 'transferência',
      'value': 79.99,
      'createdAt': DateTime.now(),
      'userId': 1,
    },
  ];

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
      body: Padding(
        padding: const EdgeInsets.only(bottom: 56),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 24, 12, 32),
                child: TransactionListFilter(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  'Maio',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            TransactionList(transactions: transactions),
            SliverToBoxAdapter(child: SizedBox(height: 32)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  'Maio',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            TransactionList(transactions: transactions),
            SliverToBoxAdapter(child: SizedBox(height: 32)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  'Maio',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            TransactionList(transactions: transactions),
          ],
        ),
      ),
    );
  }
}
