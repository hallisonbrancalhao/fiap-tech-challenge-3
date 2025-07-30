import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_challenge_3/domain/usecases/pin/create_pin.dart';
import 'package:tech_challenge_3/domain/usecases/pin/validate_pin.dart';
import 'package:tech_challenge_3/presentation/auth/bloc/pin_state.dart';
import 'package:tech_challenge_3/service_locator.dart';

class PinCubit extends Cubit<PinState> {
  final _createPinUseCase = sl<CreatePinUseCase>();
  final _validatePinUseCase = sl<ValidatePinUseCase>();

  PinCubit() : super(PinInitial());

  Future<void> createPin(String pinValue) async {
    emit(PinLoading());

    final result = await _createPinUseCase.call(param: pinValue);
    result.fold(
      (error) => emit(PinError(errorMessage: error)),
      (_) => emit(PinCreated()),
    );
  }

  Future<void> validatePin(String pinValue) async {
    emit(PinLoading());

    final result = await _validatePinUseCase.call(param: pinValue);
    result.fold((error) => emit(PinError(errorMessage: error)), (isValid) {
      if (isValid) {
        emit(PinValidated());
      } else {
        emit(
          PinValidationFailed(
            errorMessage: 'PIN incorreto',
            remainingAttempts: 2,
          ),
        );
      }
    });
  }

  void resetState() {
    emit(PinInitial());
  }
}
