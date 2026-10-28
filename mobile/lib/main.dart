import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sunshare_api/sunshare_api.dart';

/// Adresse de l'API, modifiable au lancement :
/// flutter run --dart-define=API_URL=http://10.0.2.2:8000   (émulateur Android)
const apiUrl = String.fromEnvironment('API_URL', defaultValue: 'http://localhost:8000');

final dioProvider = Provider<Dio>(
  (ref) => Dio(BaseOptions(
    baseUrl: apiUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  )),
);

/// Client généré (mobile/packages/sunshare_api) : authApi, profilApi, techniqueApi…
final apiProvider = Provider<SunshareApi>((ref) => SunshareApi(dio: ref.watch(dioProvider)));

final healthProvider = FutureProvider<HealthOut>((ref) async {
  final response = await ref.watch(apiProvider).getTechniqueApi().health();
  return response.data!;
});

void main() => runApp(const ProviderScope(child: SunShareApp()));

class SunShareApp extends StatelessWidget {
  const SunShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SunShare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.amber),
      home: const HealthScreen(),
    );
  }
}

class HealthScreen extends ConsumerWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final health = ref.watch(healthProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('SunShare')),
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
        onPressed: () => ref.invalidate(healthProvider),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
