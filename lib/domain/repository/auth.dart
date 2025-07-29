import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/data/models/signin_req_params.dart';
import 'package:tech_challenge_3/data/models/signup_req_params.dart';
import 'package:tech_challenge_3/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either> signup(SignupReqParams signupReq);
  Future<Either> signin(SigninReqParams signinReq);
  Future<bool> isLoggedIn();
   Future<Either<String, UserEntity>> getUser(); 
  Future<Either> logout();
}
