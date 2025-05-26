import 'package:flutter/material.dart';

import 'package:tech_challenge_3/presentation/transaction/widgets/date_picker.dart';

class TransactionListFilter extends StatefulWidget {
  const TransactionListFilter({super.key});

  @override
  State<TransactionListFilter> createState() => _TransactionListFilterState();
}

class _TransactionListFilterState extends State<TransactionListFilter> {
  List<String> transactionTypesFilter = [];

  void _clearFilters() {}

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 4.0,
      spacing: 8.0,
      children: [
        ...['Depósito', 'Saque', 'Transferência'].map((String type) {
          return FilterChip(
            label: Text(type),
            selected: transactionTypesFilter.contains(type),
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  transactionTypesFilter.add(type);
                } else {
                  transactionTypesFilter.remove(type);
                }
              });
            },
            showCheckmark: false,
          );
        }),
        DatePicker(),
        TextButton(onPressed: _clearFilters, child: Text('Limpar filtros')),
      ],
    );
  }
}
