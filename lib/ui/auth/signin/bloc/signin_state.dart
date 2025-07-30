part of 'signin_bloc.dart';

final class SignInState extends Equatable {
  const SignInState({this.username = '', this.email = '', this.password = ''});

  final String username;
  final String email;
  final String password;

  SignInState copyWith({String? username, String? email, String? password}) {
    return SignInState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props => [username, email, password];
}
