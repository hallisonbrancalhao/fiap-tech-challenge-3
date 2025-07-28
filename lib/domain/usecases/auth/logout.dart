import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/core/usecase/usecase.dart';
import 'package:tech_challenge_3/domain/repository/auth.dart';
import 'package:tech_challenge_3/service_locator.dart';

class LogoutUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({param}) async {
    final authRepository = sl<AuthRepository>();
    final result = await authRepository.logout();

    return result.fold(
      (data) async {
        await authRepository.removeTokensFromLocal();
        return Left(null);
      },
      (error) {
        return Right(error);
      },
    );
  }
}
