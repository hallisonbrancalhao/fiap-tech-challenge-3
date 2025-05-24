import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/core/usecase/usecase.dart';
import 'package:tech_challenge_3/domain/repository/auth.dart';
import 'package:tech_challenge_3/service_locator.dart';

class GetUserUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({dynamic param}) async {
    return sl<AuthRepository>().getUser();
  }
}
