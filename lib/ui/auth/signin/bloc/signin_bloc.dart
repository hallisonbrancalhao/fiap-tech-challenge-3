import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:tech_challenge_3/data/models/signin_req_params.dart';
import 'package:tech_challenge_3/domain/usecases/auth/signin.dart';
import 'package:tech_challenge_3/service_locator.dart';

part 'signin_state.dart';
part 'signin_events.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(const SignInState()) {
    on<UsernameChanged>(_onUsernameChanged);
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<SignInSubmit>(_onSubmit);
  }

  void _onUsernameChanged(UsernameChanged event, Emitter<SignInState> emit) {
    emit(state.copyWith(username: event.username));
  }

  void _onEmailChanged(EmailChanged event, Emitter<SignInState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<SignInState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onSubmit(SignInSubmit event, Emitter<SignInState> emit) async {
    final signInParams = SigninReqParams(
      email: state.email,
      password: state.password,
    );

    final result = await sl<SigninUseCase>().call(param: signInParams);

    result.fold((error) {}, (_) {});
  }
}
