import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_challenge_3/domain/entities/user.dart';
import 'package:tech_challenge_3/domain/usecases/auth/get_user.dart';
import 'package:tech_challenge_3/presentation/home/bloc/user_display_state.dart';
import 'package:tech_challenge_3/service_locator.dart';

class UserDisplayCubit extends Cubit<UserDisplayState> {
  UserDisplayCubit() : super(UserLoading());

  void displayUser() async {
    emit(UserLoading());

    try {
      final UserEntity user = await sl<GetUserUseCase>().call(param: '');

      emit(UserLoaded(userEntity: user));
    } catch (e) {
      emit(LoadUserFailure(errorMessage: e.toString()));
    }
  }
}
