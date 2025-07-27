import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/data/models/signin_req_params.dart';
import 'package:tech_challenge_3/data/models/signup_req_params.dart';

abstract class AuthService {
  Future<Either> signup(SignupReqParams signupReq);
  Future<Either> getUser();
  Future<Either> signin(SigninReqParams signinReq);
  Future<Either> logout();
}
