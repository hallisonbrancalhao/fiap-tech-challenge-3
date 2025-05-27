// lib/presentation/statement/pages/statement_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_challenge_3/core/configs/theme/app_theme.dart';
import 'package:tech_challenge_3/core/routes/app_routes.dart';
import 'package:tech_challenge_3/presentation/transactions/bloc/transactions_display_cubit.dart';
import 'package:tech_challenge_3/presentation/transactions/pages/transaction_list_item.dart';

class StatementPage extends StatefulWidget {
  static const String routeName = AppRoutes.listTransactions;

  const StatementPage({super.key});

  @override
  State<StatementPage> createState() => _StatementPageState();
}

class _StatementPageState extends State<StatementPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TransactionsDisplayCubit()..fetchTransactions(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppTheme.appTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text(
            'Extrato de Transações',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppTheme.appTheme.primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<TransactionsDisplayCubit, TransactionsDisplayState>(
          builder: (context, state) {
            if (state is TransactionsDisplayLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppTheme.appTheme.primaryColor,
                ),
              );
            } else if (state is TransactionsDisplayLoaded) {
              if (state.transactions.isEmpty) {
                return const Center(
                  child: Text(
                    'Nenhuma transação encontrada.',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh:
                    () =>
                        context
                            .read<TransactionsDisplayCubit>()
                            .fetchTransactions(),
                color: AppTheme.appTheme.primaryColor,
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: state.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = state.transactions[index];
                    return TransactionListItem(transaction: transaction);
                  },
                ),
              );
            } else if (state is TransactionsDisplayError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Erro ao carregar transações: ${state.errorMessage}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.appTheme.primaryColor,
                      ),
                      onPressed:
                          () =>
                              context
                                  .read<TransactionsDisplayCubit>()
                                  .fetchTransactions(),
                      child: const Text(
                        'Tentar Novamente',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Center(
              child: Text('Iniciando...', style: TextStyle(fontSize: 16)),
            );
          },
        ),
      ),
    );
  }
}
