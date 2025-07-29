import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/data/models/pin_dto.dart';
import 'package:tech_challenge_3/data/source/pin_local_service.dart';
import 'package:tech_challenge_3/domain/entities/pin.dart';
import 'package:tech_challenge_3/domain/repository/pin.dart';
import 'package:tech_challenge_3/service_locator.dart';

class PinRepositoryImpl implements PinRepository {
  @override
  Future<Either<String, Pin>> getPin() async {
    final result = await sl<PinLocalService>().getPin();
    return result.fold(
      (error) => Left(error),
      (pinDto) => Right(
        pinDto?.toEntity() ?? Pin(value: '', createdAt: DateTime.now()),
      ),
    );
  }

  @override
  Future<Either<String, void>> savePin(Pin pin) async {
    final pinDto = PinDto.fromEntity(pin);
    return sl<PinLocalService>().savePin(pinDto);
  }

  @override
  Future<Either<String, void>> deletePin() async {
    return sl<PinLocalService>().deletePin();
  }

  @override
  Future<Either<String, bool>> validatePin(String pinValue) async {
    final result = await sl<PinLocalService>().getPin();
    return result.fold((error) => Left(error), (pinDto) {
      if (pinDto == null) {
        return const Right(false);
      }
      return Right(pinDto.value == pinValue);
    });
  }

  @override
  Future<Either<String, void>> updateLastUsedAt() async {
    return sl<PinLocalService>().updateLastUsedAt();
  }
}
