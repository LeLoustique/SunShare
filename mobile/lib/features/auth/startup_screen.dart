import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api_errors.dart';
import 'auth_controller.dart';

/// Affiché pendant la restauration de la session au lancement, ou si elle a échoué (réseau).
class StartupScreen extends ConsumerWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: auth.hasError && !auth.isLoading
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 56, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(errorMessage(auth.error!), textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => ref.invalidate(authControllerProvider),
                      child: const Text('Réessayer'),
                    ),
                  ],
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
