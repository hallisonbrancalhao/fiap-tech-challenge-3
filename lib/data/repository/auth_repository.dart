import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tech_challenge_3/data/models/signin_req_params.dart';
import 'package:tech_challenge_3/domain/entities/user.dart';
import 'package:tech_challenge_3/domain/repository/auth_repository.dart';
import 'package:tech_challenge_3/domain/source/auth_service.dart';
import 'package:tech_challenge_3/domain/source/local_service.dart';

import '../models/signup_req_params.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthService authService;
  final LocalService localService;

  AuthRepositoryImpl({required this.authService, required this.localService});

  @override
  Future<Either<String, UserCredential>> signUp(
    SignupReqParams signupReq,
  ) async {
    Either result = await authService.signUp(signupReq);
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
  Future<Either<String, UserEntity>> signIn(SigninReqParams signinReq) async {
    Either result = await authService.signIn(signinReq);
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
  Future<Either<String, UserEntity?>> getUser() async {
    Either result = await authService.getUser();
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
      },
    );
  }

  @override
  Future<Either<String, void>> signOut() async {
    try {
      await authService.signOut();
      return Right(null);
    } catch (error) {
      return Left('Failed to logout from API: $error');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await localService.isLoggedIn();
  }

  @override
  Future<Either<String, void>> removeTokensFromLocal() async {
    try {
      await localService.removeTokens();
      return Right(null);
    } catch (error) {
      return Left('Failed to remove tokens from local storage: $error');
    }
  }

  @override
  Future<Either<String, void>> saveUserToken(String token) async {
    try {
      await localService.setToken('token', token);
      return Right(null);
    } catch (error) {
      return Left('Failed to save user token: $error');
    }
  }
}
