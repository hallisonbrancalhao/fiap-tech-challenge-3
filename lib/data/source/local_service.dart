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
  Future<Either> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    return const Right(true);
  }
}
