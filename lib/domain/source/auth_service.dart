import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';

import 'package:tech_challenge_3/data/models/signin_req_params.dart';
import 'package:tech_challenge_3/data/models/signup_req_params.dart';

abstract class AuthService {
  Future<Either<String, UserCredential>> signUp(SignupReqParams signupReq);
  Future<Either<String, UserCredential>> signIn(SigninReqParams signinReq);
  Future<Either<String, User?>> getUser();
  Future<Either<String, void>> signOut();
}
