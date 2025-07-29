import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/core/usecase/usecase.dart';
import 'package:tech_challenge_3/domain/entities/pin.dart';
import 'package:tech_challenge_3/domain/repository/pin.dart';
import 'package:tech_challenge_3/service_locator.dart';

class CreatePinUseCase implements UseCase<Either<String, void>, String> {
  @override
  Future<Either<String, void>> call({String? param}) async {
    if (param == null || param.isEmpty) {
      return const Left('PIN não pode estar vazio');
    }

    if (param.length != 4) {
      return const Left('PIN deve ter exatamente 4 dígitos');
    }

    if (!RegExp(r'^[0-9]{4}').hasMatch(param)) {
      return const Left('PIN deve conter apenas números');
    }

    final pin = Pin(value: param, createdAt: DateTime.now());

    return sl<PinRepository>().savePin(pin);
  }
}
