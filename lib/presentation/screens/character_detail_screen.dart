import 'package:animate_do/animate_do.dart';
import 'package:demo_rick_and_morty/core/utils/parsers.dart';
import 'package:demo_rick_and_morty/presentation/providers/character_providers.dart';
import 'package:demo_rick_and_morty/presentation/widgets/character_detail.dart';
import 'package:demo_rick_and_morty/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CharacterDetailScreen extends ConsumerWidget {
  final String characterId;
  const CharacterDetailScreen({super.key, required this.characterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getCharacter = ref.watch(characterDetailProvider(characterId));
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Brightness brightness = Theme.of(context).brightness;

    return getCharacter.when(
        data: (character) {
          return Scaffold(
            appBar: AppBar(
              title: Text(character.name!),
            ),
            body: Center(child: CharacterDetail(character: character)),
          );
        },
        error: (err, stack) => Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off,
                        color: colors.error,
                        size: height * 0.1,
                      ),
                      Text(
                        'Ha ocurrido un error al cargar los datos\nRevise su conexión a internet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: colors.error,
                            fontSize: textTheme.bodyLarge!.fontSize),
                      ),
                      SizedBox(height: height*0.02),
                      FilledButton(
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            )
                          )
                        ),
                          onPressed: () => context.replace('/home'),
                          child: Text('Regresar'))
                    ],
                  ),
                )),
        loading: () => Scaffold(
                body: ZoomIn(
                    child: Center(
                      child: Loading(
                        sizePercent: 30,
                      ),
                    ))));
  }
}
