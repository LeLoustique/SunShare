import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sunshare_api/sunshare_api.dart';

import '../../core/api.dart';

final healthProvider = FutureProvider<HealthOut>((ref) async {
  final response = await ref.watch(apiProvider).getTechniqueApi().health();
  return response.data!;
});

/// Diagnostic : l'API et la base répondent-elles ? (accessible connecté ou non)
class HealthScreen extends ConsumerWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final health = ref.watch(healthProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('État du serveur')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: health.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, _) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off, size: 56, color: Colors.red),
                const SizedBox(height: 16),
                const Text('API injoignable', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 8),
                Text('$error', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => ref.invalidate(healthProvider),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
            data: (data) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, size: 56, color: Colors.green),
                  const SizedBox(height: 16),
                  Text('API : ${data.status}', style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 8),
                  for (final ext in data.extensions.entries) Text('${ext.key} ${ext.value}'),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Actualiser',
        onPressed: () => ref.invalidate(healthProvider),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
