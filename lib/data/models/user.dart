import 'package:tech_challenge_3/domain/entities/user.dart';

class UserModel {
  final String uid;
  final String email;
  final String username;

  UserModel({required this.uid, required this.email, required this.username});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
    );
  }
}

extension UserXModel on UserModel {
  UserEntity toEntity() {
    return UserEntity(uid: uid, email: email, username: username);
  }
}
