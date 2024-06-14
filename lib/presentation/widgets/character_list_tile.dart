import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/character_response_model.dart';

class CharacterListTile extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final String? status;
  final String? species;
  final dynamic onTap;

  const CharacterListTile(
      {super.key,
      this.name,
      this.status,
      this.species,
      this.imageUrl,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Brightness brightness = Theme.of(context).brightness;

    return ListTile(
      leading: CircleAvatar(
        radius: width * 0.07,
        child: ClipOval(
            child: CachedNetworkImage(
          imageUrl: imageUrl!,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        )),
      ),
      title: Text(
        name ?? 'Unknown',
        style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold),
      ),
      subtitle: Text('${status ?? 'Unknown'}, ${species ?? 'Unknown'}'),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: colors.primary,
      ),
      onTap: onTap,
    );
  }
}
