import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  static NumberFormat currencyFormatter = NumberFormat.simpleCurrency(
    locale: 'pt_BR',
    decimalDigits: 2,
  );

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text('Maio', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        ...transactions.map((transaction) {
          return ListTile(
            title: Text(transaction['type']),
            subtitle: Text(currencyFormatter.format(transaction['value'])),
            trailing: Text(transaction['createdAt'].toString()),
            onTap: () {
              Navigator.pushNamed(context, '/update-transaction');
            },
          );
        }),
      ],
    );
  }
}
