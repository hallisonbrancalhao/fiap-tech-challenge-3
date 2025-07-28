import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';

import 'package:tech_challenge_3/domain/source/auth_service.dart';
import '../models/signin_req_params.dart';
import '../models/signup_req_params.dart';

class AuthServiceImpl implements AuthService {
  @override
  Future<Either<UserCredential, String>> signUp(
    SignupReqParams signupReq,
  ) async {
    try {
      UserCredential createdUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: signupReq.email,
            password: signupReq.password,
          );
      await createdUser.user?.updateDisplayName(signupReq.username);
      await createdUser.user?.reload();
      return Left(createdUser);
    } on FirebaseAuthException catch (e) {
      return Right(e.message ?? 'An error occurred during signup');
    }
  }

  @override
  Future<Either<UserCredential, String>> signIn(
    SigninReqParams signinReq,
  ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: signinReq.email,
            password: signinReq.password,
          );
      return Left(userCredential);
    } on FirebaseAuthException catch (e) {
      return Right(e.message ?? 'An error occurred during signin');
    }
  }

  @override
  Future<Either<User?, String>> getUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      return Left(user);
    } on FirebaseAuthException catch (e) {
      return Right(e.message ?? 'An error occurred while fetching user');
    }
  }

  @override
  Future<Either<void, String>> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return Left(null);
    } on FirebaseAuthException catch (e) {
      return Right(e.message ?? 'An error occurred during logout');
    }
  }
}
