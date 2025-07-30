import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_challenge_3/data/models/pin_dto.dart';
import 'package:tech_challenge_3/domain/source/pin_local_service.dart';

class PinLocalServiceImpl implements PinLocalService {
  static const String _pinKey = 'user_pin';
  static const String _lastUsedAtKey = 'pin_last_used_at';

  @override
  Future<Either<String, PinDto?>> getPin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pinValue = prefs.getString(_pinKey);
      final lastUsedAtString = prefs.getString(_lastUsedAtKey);

      if (pinValue == null) {
        //Para simulação de PINs existentes
        final pin = PinDto(
          value: '5678',
          createdAt: DateTime.now(),
          lastUsedAt:
              lastUsedAtString != null
                  ? DateTime.parse(lastUsedAtString)
                  : null,
        );
        return Right(pin);
      }

      final lastUsedAt =
          lastUsedAtString != null ? DateTime.parse(lastUsedAtString) : null;

      final pin = PinDto(
        value: pinValue,
        createdAt:
            DateTime.now(), // Para PINs existentes, usamos agora como createdAt
        lastUsedAt: lastUsedAt,
      );

      return Right(pin);
    } catch (e) {
      return Left('Erro ao obter PIN: $e');
    }
  }

  @override
  Future<Either<String, void>> savePin(PinDto pin) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_pinKey, pin.value);
      return const Right(null);
    } catch (e) {
      return Left('Erro ao salvar PIN: $e');
    }
  }

  @override
  Future<Either<String, void>> deletePin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_pinKey);
      await prefs.remove(_lastUsedAtKey);
      return const Right(null);
    } catch (e) {
      return Left('Erro ao deletar PIN: $e');
    }
  }

  @override
  Future<Either<String, void>> updateLastUsedAt() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastUsedAtKey, DateTime.now().toIso8601String());
      return const Right(null);
    } catch (e) {
      return Left('Erro ao atualizar último uso: $e');
    }
  }
}
