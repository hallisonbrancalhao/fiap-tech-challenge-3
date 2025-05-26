import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/signin_req_params.dart';
import '../models/signup_req_params.dart';

abstract class AuthApiService {
  Future<Either> signup(SignupReqParams signupReq);
  Future<Either> getUser();
  Future<Either> signin(SigninReqParams signinReq);
}

class AuthApiServiceImpl extends AuthApiService {
  @override
  Future<Either> signup(SignupReqParams signupReq) async {
    try {
      UserCredential createdUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: signupReq.email,
            password: signupReq.password,
          );
      await createdUser.user?.updateDisplayName(signupReq.username);
      await createdUser.user?.reload();
      return Right(createdUser);
    } on FirebaseAuthException catch (e) {
      return Left(e.message);
    }
  }

  @override
  Future<Either> getUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user?.uid != null) {
        return Right(user);
      } else {
        return Left('No user found');
      }
    } on FirebaseAuthException catch (e) {
      return Left(e.message);
    }
  }

  @override
  Future<Either> signin(SigninReqParams signinReq) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: signinReq.email,
            password: signinReq.password,
          );
      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      return Left(e.message);
    }
  }
}
