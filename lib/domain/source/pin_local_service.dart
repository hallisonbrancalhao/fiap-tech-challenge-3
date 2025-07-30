import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/data/models/pin_dto.dart';

abstract class PinLocalService {
  Future<Either<String, PinDto?>> getPin();
  Future<Either<String, void>> savePin(PinDto pin);
  Future<Either<String, void>> deletePin();
  Future<Either<String, void>> updateLastUsedAt();
}
