import 'package:animate_do/animate_do.dart';
import 'package:demo_rick_and_morty/presentation/widgets/character_list_tile.dart';
import 'package:demo_rick_and_morty/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Brightness brightness = Theme.of(context).brightness;

    return ZoomIn(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Rick & Morty',
          style: TextStyle(color: colors.primary),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: colors.primary,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, snapshot) {
          return CharacterListTile(
            imageUrl: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
            name: 'Rick Sanchez',
            status: 'Alive',
            species: 'Human',
          );
      }),
    ));
  }
}
