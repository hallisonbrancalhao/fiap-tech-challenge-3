import 'package:flutter/material.dart';

class TransactionListFilter extends StatefulWidget {
  const TransactionListFilter({super.key});

  @override
  State<TransactionListFilter> createState() => _TransactionListFilterState();
}

class _TransactionListFilterState extends State<TransactionListFilter> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Chip(label: Text('Depósito')),
        SizedBox(width: 8),
        Chip(label: Text('Transferência')),
        SizedBox(width: 8),
        OutlinedButton(child: Text('Data'), onPressed: null),
      ],
    );
  }
}
