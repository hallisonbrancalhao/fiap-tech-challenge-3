import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/core/usecase/usecase.dart';
import 'package:tech_challenge_3/domain/repository/pin_repository.dart';
import 'package:tech_challenge_3/service_locator.dart';

class ValidatePinUseCase implements UseCase<Either<String, bool>, String> {
  @override
  Future<Either<String, bool>> call({String? param}) async {
    if (param == null || param.isEmpty) {
      return const Left('PIN não pode estar vazio');
    }

    if (param.length != 4) {
      return const Left('PIN deve ter exatamente 4 dígitos');
    }

    if (!RegExp(r'^[0-9]{4}').hasMatch(param)) {
      return const Left('PIN deve conter apenas números');
    }

    final result = await sl<PinRepository>().validatePin(param);

    return result.fold((error) => Left(error), (isValid) async {
      if (isValid) {
        await sl<PinRepository>().updateLastUsedAt();
      }
      return Right(isValid);
    });
  }
}
