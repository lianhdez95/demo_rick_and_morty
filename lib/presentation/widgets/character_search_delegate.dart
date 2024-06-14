import 'package:demo_rick_and_morty/core/utils/parsers.dart';
import 'package:demo_rick_and_morty/presentation/widgets/character_list_tile.dart';
import 'package:demo_rick_and_morty/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/character_response_model.dart';
import '../../domain/repository/remote_character_repository.dart';

class CharacterSearchDelegate extends SearchDelegate<Character> {
  final CharacterRepository characterRepository;

  CharacterSearchDelegate(this.characterRepository);

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
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder<List<Character>>(
      future: characterRepository.filterCharactersByName(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Loading(sizePercent: 30,));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
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
}