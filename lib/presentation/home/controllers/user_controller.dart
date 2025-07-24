import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_challenge_3/domain/entities/user.dart';
import 'package:tech_challenge_3/domain/usecases/auth/get_user.dart';

class UserController extends StateNotifier<AsyncValue<UserEntity>> {
  final GetUserUseCase _useCase;

  UserController(this._useCase) : super(const AsyncValue.loading()) {
    loadUser();
  }

  Future<void> loadUser() async {
    state = const AsyncValue.loading();

    final result = await _useCase.call();
    result.fold(
      (error) => state = AsyncValue.error(error, StackTrace.current),
      (user) => state = AsyncValue.data(user),
    );
  }

  Future<void> refreshUser() async {
    await loadUser();
  }

  String getFormattedName(UserEntity user) {
    return user.username.isNotEmpty ? user.username : 'Usuário';
  }

  // mask e-mail for privacy (function to show reactivity with the provider in UserProvider)
  String getMaskedEmail(UserEntity user) {
    if (user.email.isEmpty) return '';

    final parts = user.email.split('@');
    if (parts.length != 2) return user.email;

    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) return user.email;

    final maskedUsername =
        '${username[0]}${'*' * (username.length - 2)}${username[username.length - 1]}';
    return '$maskedUsername@$domain';
  }
}
