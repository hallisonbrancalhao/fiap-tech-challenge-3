import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_challenge_3/data/models/signin_req_params.dart';
import 'package:tech_challenge_3/data/source/auth_api_service.dart';
import 'package:tech_challenge_3/data/source/auth_local_service.dart';
import 'package:tech_challenge_3/domain/entities/user.dart';
import 'package:tech_challenge_3/domain/repository/auth.dart';
import 'package:tech_challenge_3/service_locator.dart';

import '../models/signup_req_params.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signup(SignupReqParams signupReq) async {
    Either result = await sl<AuthApiService>().signup(signupReq);
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) async {
        UserCredential userCredentials = data;
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('token', userCredentials.user?.uid ?? '');
        return Right(userCredentials);
      },
    );
  }

  @override
  Future<Either> signin(SigninReqParams signinReq) async {
    Either result = await sl<AuthApiService>().signin(signinReq);
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) async {
        UserCredential userCredentials = data;

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        if (userCredentials.user?.email == null ||
            userCredentials.user?.uid == null) {
          return Left('User not found');
        }

        UserEntity user = UserEntity(
          uid: userCredentials.user!.uid,
          username: userCredentials.user!.displayName ?? '',
          email: userCredentials.user!.email ?? '',
        );

        sharedPreferences.setString('token', userCredentials.user?.uid ?? '');
        return Right(user);
      },
    );
  }

  @override
  Future<bool> isLoggedIn() async {
    return await sl<AuthLocalService>().isLoggedIn();
  }

  @override
  Future<Either> getUser() async {
    Either result = await sl<AuthApiService>().getUser();
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        final firebaseUser = data as User;
        final user = UserEntity(
          uid: firebaseUser.uid,
          username: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
        );
        return Right(user);
      },
    );
  }

  @override
  Future<Either> logout() async {
    try {
      await sl<AuthApiService>().logout();
    } catch (error) {
      return Left('Failed to logout from API: $error');
    }
    return await sl<AuthLocalService>().logout();
  }
}
