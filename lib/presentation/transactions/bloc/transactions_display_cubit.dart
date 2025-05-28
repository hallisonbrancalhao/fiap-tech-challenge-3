// lib/presentation/statement/bloc/transactions_display_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_challenge_3/domain/entities/transaction.dart';
import 'package:tech_challenge_3/domain/usecases/transactions/get_transactions.dart'; // UseCase criado
import 'package:tech_challenge_3/service_locator.dart';

part 'transactions_display_state.dart';

class TransactionsDisplayCubit extends Cubit<TransactionsDisplayState> {
  final _getTransactionsUseCase = sl<GetTransactionsUseCase>();

  TransactionsDisplayCubit({GetTransactionsUseCase? getTransactionsUseCase})
    : super(TransactionsDisplayInitial());

  Future<void> fetchTransactions() async {
    emit(TransactionsDisplayLoading());
    final result = await _getTransactionsUseCase.call();
    result.fold(
      (error) => emit(TransactionsDisplayError(errorMessage: error)),
      (transactions) {
        final txList = List<TransactionEntity>.from(transactions);
        txList.sort((a, b) => b.date.compareTo(a.date));
        emit(TransactionsDisplayLoaded(transactions: txList));
      },
    );
  }
}
