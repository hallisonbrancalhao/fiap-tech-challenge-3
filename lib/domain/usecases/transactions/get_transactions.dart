import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/core/usecase/usecase.dart';
import 'package:tech_challenge_3/domain/entities/transaction.dart';
import 'package:tech_challenge_3/domain/repository/auth_repository.dart';
import 'package:tech_challenge_3/domain/repository/transactions_repository.dart';
import 'package:tech_challenge_3/service_locator.dart';

class GetTransactionsUseCase
    implements UseCase<Either<String, List<TransactionEntity>>, String?> {
  @override
  Future<Either<String, List<TransactionEntity>>> call({String? param}) async {
    if (param != null && param.isNotEmpty) {
      final result = await sl<TransactionsRepository>().getTransactions(param);
      return result.fold(
        (empty) => Right([]),
        (transactions) => Right(transactions),
      );
    }

    final userId = await sl<AuthRepository>().getLocalUserUid();
    return userId.fold((error) => Left('User is not authenticated'), (
      uid,
    ) async {
      final result = await sl<TransactionsRepository>().getTransactions(uid);
      return result.fold(
        (error) => Right([]),
        (transactions) => Right(transactions),
      );
    });
  }
}
