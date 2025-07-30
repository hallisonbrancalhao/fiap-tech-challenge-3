abstract class PinState {}

class PinInitial extends PinState {}

class PinLoading extends PinState {}

class PinCreated extends PinState {
  final String message;
  PinCreated({this.message = 'PIN criado com sucesso'});
}

class PinValidated extends PinState {
  final String message;
  PinValidated({this.message = 'PIN validado com sucesso'});
}

class PinError extends PinState {
  final String errorMessage;
  PinError({required this.errorMessage});
}

class PinValidationFailed extends PinState {
  final String errorMessage;
  final int remainingAttempts;
  PinValidationFailed({
    required this.errorMessage,
    required this.remainingAttempts,
  });
}

class PinDeleted extends PinState {
  final String message;
  PinDeleted({this.message = 'PIN deletado com sucesso'});
}
