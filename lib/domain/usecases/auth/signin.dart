import 'package:dartz/dartz.dart';

import 'package:tech_challenge_3/data/models/signin_req_params.dart';
import 'package:tech_challenge_3/domain/repository/auth_repository.dart';
import 'package:tech_challenge_3/core/usecase/usecase.dart';
import 'package:tech_challenge_3/service_locator.dart';

class SigninUseCase implements UseCase<Either, SigninReqParams> {
  @override
  Future<Either> call({SigninReqParams? param}) async {
    final result = await sl<AuthRepository>().signIn(param!);

    return result.fold(
      (error) {
        return Right(error);
      },
      (data) async {
        await sl<AuthRepository>().saveUserToken(data.uid);
        return Left(data);
      },
    );
  }
}
