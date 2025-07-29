import 'package:tech_challenge_3/core/usecase/usecase.dart'; 
import 'package:tech_challenge_3/domain/entities/user.dart';
import 'package:tech_challenge_3/domain/repository/auth.dart' as domain_auth_repo;


class GetUserUseCase implements UseCase<UserEntity, String> {
  final domain_auth_repo.AuthRepository repository;

  GetUserUseCase(this.repository);

  @override
  Future<UserEntity> call({String? param}) async {
    final result = await repository.getUser();
    return result.fold(
      (errorMessage) {
        throw Exception(errorMessage);
      },
      (userEntity) => userEntity,
    );
  }
}