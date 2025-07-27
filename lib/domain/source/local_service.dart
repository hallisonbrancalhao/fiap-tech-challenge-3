import 'package:dartz/dartz.dart';

abstract class LocalService {
  Future<bool> isLoggedIn();
  Future<Either> logout();
}
