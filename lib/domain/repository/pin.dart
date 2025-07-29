import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/domain/entities/pin.dart';

abstract class PinRepository {
  Future<Either<String, Pin>> getPin();
  Future<Either<String, void>> savePin(Pin pin);
  Future<Either<String, void>> deletePin();
  Future<Either<String, bool>> validatePin(String pinValue);
  Future<Either<String, void>> updateLastUsedAt();
}
