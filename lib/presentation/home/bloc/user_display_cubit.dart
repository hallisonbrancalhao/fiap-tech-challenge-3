import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_challenge_3/domain/entities/user.dart';
import 'package:tech_challenge_3/domain/usecases/get_user.dart';
import 'package:tech_challenge_3/presentation/home/bloc/user_display_state.dart';
import 'package:tech_challenge_3/service_locator.dart';

class UserDisplayCubit extends Cubit<UserDisplayState> {
  UserDisplayCubit() : super(UserLoading());

  void displayUser() async {
    var result = await sl<GetUserUseCase>().call();
    result.fold(
      (error) {
        emit(LoadUserFailure(errorMessage: error));
      },
      (data) {
        UserEntity user = data;
        emit(UserLoaded(userEntity: user));
      },
    );
  }
}
