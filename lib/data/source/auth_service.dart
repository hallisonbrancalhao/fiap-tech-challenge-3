import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';

import 'package:tech_challenge_3/domain/source/auth_service.dart';
import '../models/signin_req_params.dart';
import '../models/signup_req_params.dart';

class AuthServiceImpl implements AuthService {
  @override
  Future<Either<String, UserCredential>> signUp(
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
      return Right(createdUser);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'An error occurred during signup');
    }
  }

  @override
  Future<Either<String, UserCredential>> signIn(
    SigninReqParams signinReq,
  ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: signinReq.email,
            password: signinReq.password,
          );
      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'An error occurred during signin');
    }
  }

  @override
  Future<Either<String, User?>> getUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'An error occurred while fetching user');
    }
  }

  @override
  Future<Either<String, void>> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'An error occurred during logout');
    }
  }
}
