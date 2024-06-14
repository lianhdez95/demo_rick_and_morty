import 'package:demo_rick_and_morty/core/router/app_router.dart';
import 'package:demo_rick_and_morty/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Demo Rick & Morty',
      routerConfig: appRouter,
      theme: lightMode, 
      darkTheme: darkMode,
      themeMode: ThemeMode.light,
    );
  }
}