import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';

import 'package:tech_challenge_3/data/models/signin_req_params.dart';
import 'package:tech_challenge_3/data/models/signup_req_params.dart';
import 'package:tech_challenge_3/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<UserCredential, String>> signUp(SignupReqParams signupReq);
  Future<Either<UserEntity, String>> signIn(SigninReqParams signinReq);
  Future<Either<UserEntity?, String>> getUser();
  Future<Either<void, String>> signOut();
  Future<bool> isLoggedIn();
  Future<Either<void, String>> removeTokensFromLocal();
  Future<Either<void, String>> saveUserToken(String token);
}
