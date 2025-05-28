import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tech_challenge_3/common/bloc/button/button_state_cubit.dart';
import 'package:tech_challenge_3/common/bloc/button/button_state.dart';
import 'package:tech_challenge_3/core/routes/app_routes.dart';
import 'package:tech_challenge_3/domain/usecases/auth/logout.dart';
import 'package:tech_challenge_3/presentation/auth/pages/signup.dart';
import 'package:tech_challenge_3/presentation/home/bloc/user_display_cubit.dart';
import 'package:tech_challenge_3/presentation/home/bloc/user_display_state.dart';
import 'package:tech_challenge_3/presentation/home/pages/transaction_chart.dart';
import 'package:tech_challenge_3/presentation/transactions/bloc/transactions_display_cubit.dart';
import 'package:tech_challenge_3/presentation/transactions/pages/add_transaction.dart';
import 'package:tech_challenge_3/presentation/transactions/pages/statement_page.dart';
import 'package:tech_challenge_3/service_locator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserDisplayCubit()..displayUser()),
        BlocProvider(
          create: (context) => TransactionsDisplayCubit()..fetchTransactions(),
        ),
        BlocProvider(create: (context) => ButtonStateCubit()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ButtonStateCubit, ButtonState>(
            listener: (context, state) {
              if (state is ButtonSuccessState) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupPage()),
                );
              }
              if (state is ButtonFailureState) {
                var snackBar = SnackBar(content: Text(state.errorMessage));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          ),
          BlocListener<TransactionsDisplayCubit, TransactionsDisplayState>(
            listener: (context, state) {
              if (state is TransactionsDisplayError) {
                var snackBar = SnackBar(content: Text(state.errorMessage));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                const Icon(Icons.dashboard),
                const SizedBox(width: 8),
                Text(
                  'Dashboard',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context.read<ButtonStateCubit>().excute(
                    usecase: sl<LogoutUseCase>(),
                  );
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SvgPicture.asset(
                    'assets/images/pixels_top.svg',
                    fit: BoxFit.contain,
                    alignment: Alignment.topCenter,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SvgPicture.asset(
                    'assets/images/pixels_bottom.svg',
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<UserDisplayCubit, UserDisplayState>(
                          builder: (context, state) {
                            if (state is UserLoaded) {
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Text(
                                  'Olá, ${state.userEntity.username}!',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                subtitle: Text(state.userEntity.email),
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        BlocConsumer(
                          listener:
                              (context, state) =>
                                  state is TransactionsDisplayError
                                      ? ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(state.errorMessage),
                                        ),
                                      )
                                      : null,
                          bloc: context.read<TransactionsDisplayCubit>(),
                          builder: (context, state) {
                            if (state is TransactionsDisplayLoaded) {
                              final total = calculateTotal(state.transactions);
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Saldo total',
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.labelMedium,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'R\$ ${total.toStringAsFixed(2)}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              total >= 0
                                                  ? Colors.green.shade900
                                                  : Colors.red.shade900,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      TransactionsPieChart(
                                        transactions: state.transactions,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            if (state is TransactionsDisplayLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return const Text('Erro ao carregar transações.');
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _actionIcon(
                              context,
                              Icons.add_circle,
                              'Adicionar',
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CreateTransactionPage(),
                                ),
                              ),
                            ),
                            _actionIcon(
                              context,
                              Icons.list,
                              'Extrato',
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const StatementPage(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double calculateTotal(List<dynamic> transactions) {
    return transactions.fold(0.0, (sum, t) => sum + t.amount);
  }

  Widget _actionIcon(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.1),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
