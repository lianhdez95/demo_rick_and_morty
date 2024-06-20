import 'package:demo_rick_and_morty/core/utils/check_connection.dart';
import 'package:demo_rick_and_morty/core/utils/parsers.dart';
import 'package:demo_rick_and_morty/domain/repository/local_character_repository.dart';
import 'package:demo_rick_and_morty/presentation/widgets/character_list_tile.dart';
import 'package:demo_rick_and_morty/presentation/widgets/error_screen.dart';
import 'package:demo_rick_and_morty/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/character_response_model.dart';
import '../../domain/repository/remote_character_repository.dart';

class CharacterSearchDelegate extends SearchDelegate<Character> {
  final CharacterRepository remoteCharacterRepository;
  final LocalCharacterRepository localCharacterRepository;

  CharacterSearchDelegate(
      this.remoteCharacterRepository, this.localCharacterRepository);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        context.pop();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Brightness brightness = Theme.of(context).brightness;

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder<List<Character>>(
      future: getCharacters(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: Loading(
            sizePercent: 30,
          ));
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off, color: colors.error, size: height * 0.1),
                SizedBox(
                  height: height * 0.01,
                ),
                Text(
                  'Error de conexión',
                  style: textTheme.bodyLarge,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                FilledButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text('Regresar'))
              ],
            ),
          );
        } else {
          final characters = snapshot.data;
          return ListView.builder(
            itemCount: characters!.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return CharacterListTile(
                imageUrl: character.image,
                name: character.name,
                species: parseSpecies(character.species!),
                status: parseStatus(character.status!),
                onTap: () {
                  close(context, character);
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  Future<List<Character>> getCharacters() async {
    if (await isConnected()) {
      return remoteCharacterRepository.filterCharactersByName(query);
    } else {
      return localCharacterRepository.filterCharactersByName(query);
    }
  }
}
