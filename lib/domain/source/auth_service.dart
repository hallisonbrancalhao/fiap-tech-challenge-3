import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';

import 'package:tech_challenge_3/data/models/signin_req_params.dart';
import 'package:tech_challenge_3/data/models/signup_req_params.dart';

abstract class AuthService {
  Future<Either<UserCredential, String>> signUp(SignupReqParams signupReq);
  Future<Either<UserCredential, String>> signIn(SigninReqParams signinReq);
  Future<Either<User?, String>> getUser();
  Future<Either<void, String>> signOut();
}
