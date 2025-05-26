import 'package:flutter/material.dart';

import 'package:tech_challenge_3/presentation/transaction/widgets/transaction_item.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key, required this.transactions});

  final List<dynamic> transactions;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: transactions.length,
      itemBuilder: (BuildContext context, int index) {
        return TransactionItem(transaction: transactions[index]);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
