import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_challenge_3/domain/source/local_service.dart';

class LocalServiceImpl implements LocalService {
  @override
  Future<bool> isLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    if (token == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Future<Either> removeTokens() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    return const Right(true);
  }

  @override
  Future<String?> getToken(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key);
  }

  @override
  Future<Either> setToken(String key, String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(key, token);
    return const Right(true);
  }
}
