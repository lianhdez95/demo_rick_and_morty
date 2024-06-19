import 'package:animate_do/animate_do.dart';
import 'package:demo_rick_and_morty/presentation/providers/character_providers.dart';
import 'package:demo_rick_and_morty/presentation/widgets/character_detail.dart';
import 'package:demo_rick_and_morty/presentation/widgets/error_screen.dart';
import 'package:demo_rick_and_morty/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterSearchDetailScreen extends ConsumerWidget {
  final String characterId;
  const CharacterSearchDetailScreen({super.key, required this.characterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getCharacter = ref.watch(characterDetailProvider(characterId));

    return getCharacter.when(
        data: (character) {
          return Scaffold(
            appBar: AppBar(
              title: Text(character.name!),
            ),
            body: Center(child: CharacterDetail(character: character)),
          );
        },
        error: (err, stack) {
          if (err is Exception) {
            return const ErrorScreen(
                text: 'Error al obtener datos\nRevise su conexión a internet',
                redirectRoute: '/home',
                buttonText: 'Regresar',
                iconData: Icons.wifi_off);
          } else {
            // Maneja cualquier otra excepción que pueda ocurrir
            return Scaffold(
              body: Center(
                child: Text('Error al cargar los datos: $err'),
              ),
            );
          }
        },
        loading: () => Scaffold(
                body: ZoomIn(
                    child: const Center(
              child: Loading(
                sizePercent: 30,
              ),
            ))));
  }
}
