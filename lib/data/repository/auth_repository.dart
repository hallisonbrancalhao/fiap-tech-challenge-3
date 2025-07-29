import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tech_challenge_3/data/models/signin_req_params.dart';
import 'package:tech_challenge_3/domain/entities/user.dart';
import 'package:tech_challenge_3/domain/repository/auth_repository.dart';
import 'package:tech_challenge_3/domain/source/auth_service.dart';
import 'package:tech_challenge_3/domain/source/local_service.dart';
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
<<<<<<< HEAD:lib/data/repository/auth.dart
  Future<Either> signup(SignupReqParams signupReq) async {
    Either result = await authApiService.signup(signupReq); 
=======
  Future<Either<String, UserCredential>> signUp(
    SignupReqParams signupReq,
  ) async {
    Either result = await sl<AuthService>().signUp(signupReq);
>>>>>>> main:lib/data/repository/auth_repository.dart
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) async {
        UserCredential userCredentials = data;
        return Right(userCredentials);
      },
    );
  }

  @override
<<<<<<< HEAD:lib/data/repository/auth.dart
  Future<Either> signin(SigninReqParams signinReq) async {
    Either result = await authApiService.signin(signinReq);
=======
  Future<Either<String, UserEntity>> signIn(SigninReqParams signinReq) async {
    Either result = await sl<AuthService>().signIn(signinReq);
>>>>>>> main:lib/data/repository/auth_repository.dart
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) async {
        UserCredential userCredentials = data;

        if (userCredentials.user?.email == null ||
            userCredentials.user?.uid == null) {
          return Left('User not found');
        }

        UserEntity user = UserEntity(
          uid: userCredentials.user!.uid,
          username: userCredentials.user!.displayName ?? '',
          email: userCredentials.user!.email ?? '',
        );

        return Right(user);
      },
    );
  }

  @override
<<<<<<< HEAD:lib/data/repository/auth.dart
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
=======
  Future<Either<String, UserEntity?>> getUser() async {
    Either result = await sl<AuthService>().getUser();
    return result.fold(
      (error) {
        return Left(error);
      },
      (data) {
        if (data == null) {
          return Right(null);
        }

        final firebaseUser = data;
        final user = UserEntity(
          uid: firebaseUser.uid,
          username: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
        );
        return Right(user);
>>>>>>> main:lib/data/repository/auth_repository.dart
      },
    );
  }

  @override
  Future<Either<String, void>> signOut() async {
    try {
<<<<<<< HEAD:lib/data/repository/auth.dart
    } catch (error) {
      return Left('Failed to logout from API: $error');
    }
    return await authLocalService.logout(); 
=======
      await sl<AuthService>().signOut();
      return Right(null);
    } catch (error) {
      return Left('Failed to logout from API: $error');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await sl<LocalService>().isLoggedIn();
  }

  @override
  Future<Either<String, void>> removeTokensFromLocal() async {
    try {
      await sl<LocalService>().removeTokens();
      return Right(null);
    } catch (error) {
      return Left('Failed to remove tokens from local storage: $error');
    }
  }

  @override
  Future<Either<String, void>> saveUserToken(String token) async {
    try {
      await sl<LocalService>().setToken('token', token);
      return Right(null);
    } catch (error) {
      return Left('Failed to save user token: $error');
    }
>>>>>>> main:lib/data/repository/auth_repository.dart
  }
}