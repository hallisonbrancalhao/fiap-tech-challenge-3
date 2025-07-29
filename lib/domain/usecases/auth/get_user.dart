import 'package:tech_challenge_3/core/usecase/usecase.dart';
import 'package:tech_challenge_3/domain/entities/user.dart';
import 'package:tech_challenge_3/domain/repository/auth_repository.dart';
import 'package:tech_challenge_3/service_locator.dart';

class GetUserUseCase implements UseCase<UserEntity, String> {
  @override
  Future<UserEntity> call({String? param}) async {
    final result = await sl<AuthRepository>().getUser();
    return result.fold(
      (errorMessage) {
        throw Exception(errorMessage);
      },
      (user) {
        if (user == null) {
          throw Exception('User not found');
        }
        return user;
      },
    );
  }
}
