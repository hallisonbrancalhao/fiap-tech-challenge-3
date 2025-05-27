import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_challenge_3/domain/enums/transaction_type_enum.dart';
import 'package:tech_challenge_3/presentation/transactions/bloc/transactions_display_cubit.dart';

import 'package:tech_challenge_3/presentation/transactions/widgets/date_picker.dart';

class TransactionListFilter extends StatefulWidget {
  const TransactionListFilter({super.key});

  @override
  State<TransactionListFilter> createState() => _TransactionListFilterState();
}

class _TransactionListFilterState extends State<TransactionListFilter> {
  List<TransactionType> transactionTypesFilter = [];
  DateTime? transactionDate;

  void _onSelectDate(DateTime? date) {
    setState(() {
      transactionDate = date;
    });
  }

  void _clearFilters(BuildContext context) {
    setState(() {
      transactionTypesFilter = [];
      transactionDate = null;
    });
    context.read<TransactionsDisplayCubit>().fetchTransactions();
  }

  void _fiterTransactions(BuildContext blocContext) {
    context.read<TransactionsDisplayCubit>().filterTransactionsList(
      transactionTypesFilter,
      transactionDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsDisplayCubit, TransactionsDisplayState>(
      builder: (context, state) {
        return Wrap(
          runSpacing: 4.0,
          spacing: 8.0,
          children: [
            ...TransactionType.values.map((TransactionType type) {
              return FilterChip(
                label: Text(transactionTypeToString(type)),
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
            DatePicker(selectedDate: transactionDate, onSelect: _onSelectDate),
            FilledButton(
              onPressed: () => _fiterTransactions(context),
              child: Text('Filtrar'),
            ),
            TextButton(
              onPressed: () => _clearFilters(context),
              child: Text('Limpar filtros'),
            ),
          ],
        );
      },
    );
  }
}
