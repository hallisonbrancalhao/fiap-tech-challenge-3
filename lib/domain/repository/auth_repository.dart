import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';

import 'package:tech_challenge_3/data/models/signin_req_params.dart';
import 'package:tech_challenge_3/data/models/signup_req_params.dart';
import 'package:tech_challenge_3/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<String, UserCredential>> signUp(SignupReqParams signupReq);
  Future<Either<String, UserEntity>> signIn(SigninReqParams signinReq);
  Future<Either<String, UserEntity?>> getUser();
  Future<Either<String, void>> signOut();
  Future<bool> isLoggedIn();
  Future<Either<String, void>> removeTokensFromLocal();
  Future<Either<String, void>> saveUserToken(String token);
}
