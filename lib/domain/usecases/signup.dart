import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/core/usecase/usecase.dart';
import 'package:tech_challenge_3/data/models/signup_req_params.dart';
import 'package:tech_challenge_3/domain/repository/auth.dart';
import 'package:tech_challenge_3/service_locator.dart';

class SignupUseCase implements UseCase<Either, SignupReqParams> {
  @override
  Future<Either> call({SignupReqParams? param}) async {
    return sl<AuthRepository>().signup(param!);
  }
}
