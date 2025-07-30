import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/core/usecase/usecase.dart';
import 'package:tech_challenge_3/data/models/transaction_create_dto.dart';
import 'package:tech_challenge_3/domain/enums/transaction_type_enum.dart';
import 'package:tech_challenge_3/domain/repository/auth_repository.dart';
import 'package:tech_challenge_3/domain/repository/transactions_repository.dart';
import 'package:tech_challenge_3/service_locator.dart';

class CreateTransactionUseCase
    implements UseCase<Either, TransactionCreateDto> {
  @override
  Future<Either> call({TransactionCreateDto? param}) async {
    final user = await sl<AuthRepository>().getUser();

    return user.fold(
      (error) {
        return Left(error);
      },
      (user) {
        if (user == null) {
          return Left('User not authenticated');
        }
        double amount = param?.amount ?? 0;

        if (param?.type == TransactionType.withdrawal &&
            param?.type == TransactionType.transfer) {
          amount = amount * -1;
        }

        final newParams = TransactionCreateDto(
          userUid: user.uid,
          amount: amount,
          description: param?.description ?? '',
          date: param?.date ?? DateTime.now(),
          type: param?.type ?? TransactionType.deposit,
        );

        return sl<TransactionsRepository>().addTransaction(newParams);
      },
    );
  }
}
