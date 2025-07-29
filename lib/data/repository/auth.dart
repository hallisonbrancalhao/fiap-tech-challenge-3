import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_challenge_3/data/models/signin_req_params.dart';
import 'package:tech_challenge_3/data/source/auth_api_service.dart';
import 'package:tech_challenge_3/data/source/auth_local_service.dart';
import 'package:tech_challenge_3/domain/entities/user.dart';
import 'package:tech_challenge_3/domain/repository/auth.dart';
import 'package:tech_challenge_3/service_locator.dart'; // Você não precisa do sl aqui se estiver injetando tudo

import '../models/signup_req_params.dart';

class AuthRepositoryImpl extends AuthRepository {
  // DECLARE A INSTÂNCIA DO SERVIÇO AQUI
  final AuthApiService authApiService;
  final AuthLocalService authLocalService; // Adicione se for usar

  // INJETE-OS NO CONSTRUTOR
  AuthRepositoryImpl({
    required this.authApiService,
    required this.authLocalService, // Adicione se for usar
  });

  @override
  Future<Either> signup(SignupReqParams signupReq) async {
    // Agora use a instância injetada:
    Either result = await authApiService.signup(signupReq); // <<== AQUI ESTAVA sl<AuthApiService>()
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
    // Agora use a instância injetada:
    Either result = await authApiService.signin(signinReq); // <<== AQUI ESTAVA sl<AuthApiService>()
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
    // Agora use a instância injetada:
    return await authLocalService.isLoggedIn(); // <<== AQUI ESTAVA sl<AuthLocalService>()
  }

  @override
  Future<Either<String, UserEntity>> getUser() async {
    // <<== ESTA É A LINHA DA CORREÇÃO!
    final result = await authApiService.getUser(); // Use 'authApiService' (minúsculo)
    return result.fold(
      (errorMessage) => Left(errorMessage), // Passa a String de erro diretamente
      (user) {
        if (user != null) {
          return Right(UserEntity(uid: user.uid, email: user.email ?? '', username: user.displayName ?? ''));
        }
        return Left('Usuário não encontrado.'); // Se user for nulo
      },
    );
  }

  @override
  Future<Either> logout() async {
    try {
      // Agora use a instância injetada:
      await authApiService.logout(); // <<== AQUI ESTAVA sl<AuthApiService>()
    } catch (error) {
      return Left('Failed to logout from API: $error');
    }
    // Agora use a instância injetada:
    return await authLocalService.logout(); // <<== AQUI ESTAVA sl<AuthLocalService>()
  }
}