import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_challenge_3/domain/entities/user.dart';
import 'package:tech_challenge_3/domain/usecases/auth/get_user.dart';
import 'package:tech_challenge_3/presentation/home/controllers/user_controller.dart';

final getUserUseCaseProvider = Provider<GetUserUseCase>((ref) {
  return GetUserUseCase();
});

final userControllerProvider =
    StateNotifierProvider<UserController, AsyncValue<UserEntity>>((ref) {
      final useCase = ref.watch(getUserUseCaseProvider);
      return UserController(useCase);
    });

final userFormattedNameProvider = Provider<String>((ref) {
  final userAsync = ref.watch(userControllerProvider);

  return userAsync.when(
    data:
        (user) =>
            ref.read(userControllerProvider.notifier).getFormattedName(user),
    loading: () => 'Carregando...',
    error: (error, stack) => 'Erro',
  );
});

final userMaskedEmailProvider = Provider<String>((ref) {
  final userAsync = ref.watch(userControllerProvider);

  return userAsync.when(
    data:
        (user) =>
            ref.read(userControllerProvider.notifier).getMaskedEmail(user),
    loading: () => 'carregando@email.com',
    error: (error, stack) => 'erro@email.com',
  );
});
