import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';

void main() => runApp(const ProviderScope(child: SunShareApp()));

class SunShareApp extends ConsumerWidget {
  const SunShareApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'SunShare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.amber),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
