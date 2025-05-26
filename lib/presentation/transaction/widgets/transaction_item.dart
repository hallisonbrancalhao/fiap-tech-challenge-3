import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:tech_challenge_3/core/routes/app_routes.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key, required this.transaction});

  final Map transaction;

  static NumberFormat currencyFormatter = NumberFormat.simpleCurrency(
    locale: 'pt_BR',
    decimalDigits: 2,
  );

  static DateFormat dateFormatter = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(transaction['type']),
      subtitle: Text(currencyFormatter.format(transaction['value'])),
      trailing: Text(dateFormatter.format(transaction['createdAt'])),
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.updateTransaction,
          arguments: transaction['id'],
        );
      },
    );
  }
}
