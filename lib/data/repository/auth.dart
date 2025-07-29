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
  final AuthApiService authApiService;
  final AuthLocalService authLocalService;

  AuthRepositoryImpl({
    required this.authApiService,
    required this.authLocalService, 
  });

  @override
  Future<Either> signup(SignupReqParams signupReq) async {
    Either result = await authApiService.signup(signupReq); 
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
    Either result = await authApiService.signin(signinReq);
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
    return await authLocalService.isLoggedIn(); 
  }

  @override
  Future<Either<String, UserEntity>> getUser() async {
    final result = await authApiService.getUser(); 
    return result.fold(
      (errorMessage) => Left(errorMessage),
      (user) {
        if (user != null) {
          return Right(UserEntity(uid: user.uid, email: user.email ?? '', username: user.displayName ?? ''));
        }
        return Left('Usuário não encontrado.'); 
      },
    );
  }

  @override
  Future<Either> logout() async {
    try {
    } catch (error) {
      return Left('Failed to logout from API: $error');
    }
    return await authLocalService.logout(); 
  }
}