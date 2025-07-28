import 'package:dartz/dartz.dart';

import 'package:tech_challenge_3/core/usecase/usecase.dart';
import 'package:tech_challenge_3/domain/repository/auth.dart';


class GetUserUseCase implements UseCase<Either<dynamic, dynamic>, dynamic> {
  final AuthRepository repository; // AuthRepository deve ser a interface abstrata

  GetUserUseCase(this.repository);

  @override
  Future<Either<dynamic, dynamic>> call({dynamic param}) async {
    return await repository.getUser();
  }
}