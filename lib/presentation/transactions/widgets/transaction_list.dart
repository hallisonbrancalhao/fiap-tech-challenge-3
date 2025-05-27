import 'package:flutter/material.dart';
import 'package:tech_challenge_3/domain/entities/transaction.dart';
import 'package:tech_challenge_3/presentation/transactions/pages/transaction_list_item.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key, required this.transactions});

  final List<TransactionEntity> transactions;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Text(
            'Nenhuma transação encontrada.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }
    return SliverList.builder(
      itemCount: transactions.length,
      itemBuilder: (BuildContext context, int index) {
        final transaction = transactions[index];

        return TransactionListItem(transaction: transaction);
      },
    );
  }
}
