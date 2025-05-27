part of 'transactions_display_cubit.dart';

abstract class TransactionsDisplayState {}

class TransactionsDisplayInitial extends TransactionsDisplayState {}

class TransactionsDisplayLoading extends TransactionsDisplayState {}

class TransactionsDisplayLoaded extends TransactionsDisplayState {
  final List<TransactionEntity> transactions;
  TransactionsDisplayLoaded({required this.transactions});
}

class TransactionsDisplayError extends TransactionsDisplayState {
  final String errorMessage;
  TransactionsDisplayError({required this.errorMessage});
}
