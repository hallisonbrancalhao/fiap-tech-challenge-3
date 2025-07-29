import 'package:dartz/dartz.dart';

abstract class LocalService {
  Future<bool> isLoggedIn();
  Future<Either> removeTokens();
  Future<Either> setToken(String key, String token);
  Future<String?> getToken(String key);
}
