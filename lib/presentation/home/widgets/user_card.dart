import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_challenge_3/presentation/home/providers/user_provider.dart';

class UserCard extends ConsumerWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userControllerProvider);
    final formattedName = ref.watch(userFormattedNameProvider);
    final maskedEmail = ref.watch(userMaskedEmailProvider);

    return userAsync.when(
      data:
          (user) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(
              'Olá, $formattedName!',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(maskedEmail),
            trailing: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed:
                  () => ref.read(userControllerProvider.notifier).refreshUser(),
            ),
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (error, stack) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.error, color: Colors.white),
            ),
            title: const Text(
              'Erro ao carregar usuário',
              style: TextStyle(color: Colors.red),
            ),
            subtitle: Text(error.toString()),
            trailing: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed:
                  () => ref.read(userControllerProvider.notifier).refreshUser(),
            ),
          ),
    );
  }
}
