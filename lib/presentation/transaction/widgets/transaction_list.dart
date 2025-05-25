import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  static NumberFormat currencyFormatter = NumberFormat.simpleCurrency(
    locale: 'pt_BR',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('Depósito'),
          subtitle: Text(currencyFormatter.format(150.82)),
          trailing: Text('14/05/2025'),
        ),
        Divider(),
        ListTile(
          title: Text('Depósito'),
          subtitle: Text(currencyFormatter.format(150.82)),
          trailing: Text('14/05/2025'),
        ),
        Divider(),

        ListTile(
          title: Text('Depósito'),
          subtitle: Text(currencyFormatter.format(150.82)),
          trailing: Text('14/05/2025'),
        ),
      ],
    );
  }
}
