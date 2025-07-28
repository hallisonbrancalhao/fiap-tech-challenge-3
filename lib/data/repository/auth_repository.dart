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
  @override
  Future<Either<UserCredential, String>> signUp(
    SignupReqParams signupReq,
  ) async {
    Either result = await sl<AuthService>().signUp(signupReq);
    return result.fold(
      (data) async {
        UserCredential userCredentials = data;

        return Left(userCredentials);
      },
      (error) {
        return Right(error);
      },
    );
  }

  @override
  Future<Either<UserEntity, String>> signIn(SigninReqParams signinReq) async {
    Either result = await sl<AuthService>().signIn(signinReq);
    return result.fold(
      (data) async {
        UserCredential userCredentials = data;

        if (userCredentials.user?.email == null ||
            userCredentials.user?.uid == null) {
          return Right('User not found');
        }

        UserEntity user = UserEntity(
          uid: userCredentials.user!.uid,
          username: userCredentials.user!.displayName ?? '',
          email: userCredentials.user!.email ?? '',
        );

        return Left(user);
      },
      (error) {
        return Right(error);
      },
    );
  }

  @override
  Future<Either<UserEntity?, String>> getUser() async {
    Either result = await sl<AuthService>().getUser();
    return result.fold(
      (data) {
        if (data == null) {
          return Left(null);
        }

        final firebaseUser = data;
        final user = UserEntity(
          uid: firebaseUser.uid,
          username: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
        );
        return Left(user);
      },
      (error) {
        return Right(error);
      },
    );
  }

  @override
  Future<Either<void, String>> signOut() async {
    try {
      await sl<AuthService>().signOut();
      return Left(null);
    } catch (error) {
      return Right('Failed to logout from API: $error');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await sl<LocalService>().isLoggedIn();
  }

  @override
  Future<Either<void, String>> removeTokensFromLocal() async {
    try {
      await sl<LocalService>().removeTokens();
      return Left(null);
    } catch (error) {
      return Right('Failed to remove tokens from local storage: $error');
    }
  }

  @override
  Future<Either<void, String>> saveUserToken(String token) async {
    try {
      await sl<LocalService>().setToken('token', token);
      return Left(null);
    } catch (error) {
      return Right('Failed to save user token: $error');
    }
  }
}
