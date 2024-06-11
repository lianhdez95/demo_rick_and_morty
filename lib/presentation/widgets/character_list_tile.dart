import 'package:flutter/material.dart';

class CharacterListTile extends StatelessWidget {

  final String? imageUrl;
  final String? name;
  final String? status;
  final String? species;

  const CharacterListTile({
    super.key, 
    this.name, 
    this.status, 
    this.species, 
    this.imageUrl
  });

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
              child: imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      width: 2 * width * 0.07,
                      height: 2 * width * 0.07,
                    )
                  : Icon(
                      Icons.person,
                      color: colors.primary,
                    ),
            ),
          ),          title: Text(name ?? 'Unknown', style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold),),
          subtitle: Text('${status ?? 'Unknown'}, ${species ?? 'Unknown'}'),
          trailing: Icon(Icons.arrow_forward_ios, color: colors.primary,),
          onTap: () {},
        );
  }
}