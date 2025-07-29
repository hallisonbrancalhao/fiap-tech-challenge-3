import 'package:dartz/dartz.dart';

import 'package:tech_challenge_3/domain/repository/auth_repository.dart';
import 'package:tech_challenge_3/core/usecase/usecase.dart';
import 'package:tech_challenge_3/service_locator.dart';

class LogoutUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({param}) async {
    final authRepository = sl<AuthRepository>();
    final result = await authRepository.signOut();

    return result.fold(
      (error) {
        return Left(error);
      },
      (data) async {
        await authRepository.removeTokensFromLocal();
        return Right(null);
      },
    );
  }
}
