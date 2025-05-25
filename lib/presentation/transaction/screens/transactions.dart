import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  static NumberFormat currencyFormatter = NumberFormat.simpleCurrency(
    locale: 'pt_BR',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transações')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Chip(label: Text('Depósito')),
                SizedBox(width: 8),
                Chip(label: Text('Transferência')),
                SizedBox(width: 8),
                OutlinedButton(child: Text('Data'), onPressed: null),
              ],
            ),
          ),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Nova transação'),
        onPressed: () {
          Navigator.pushNamed(context, '/new-transaction');
        },
      ),
    );
  }
}
