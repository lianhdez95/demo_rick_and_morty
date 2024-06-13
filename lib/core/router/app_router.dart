import 'package:demo_rick_and_morty/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => SplashScreen(),
  ),
  GoRoute(
    path: '/home',
    builder: (context, state) => HomeScreen(),
  ),
  GoRoute(
    path: '/character/:id',
    pageBuilder: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      child: CharacterDetailScreen(characterId: state.pathParameters['id']!),
    ),
  ),
]);
