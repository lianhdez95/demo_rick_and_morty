import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/utils/parsers.dart';
import '../../data/models/character_response_model.dart';

class CharacterDetail extends StatelessWidget {
  final Character character;
  const CharacterDetail({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Brightness brightness = Theme.of(context).brightness;

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          SlideInLeft(
            child: Container(
                height: height * 0.2,
                width: height * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(height * 0.02),
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(2, 5), // changes position of shadow
                    ),
                  ],
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(height * 0.02),
                    child: CachedNetworkImage(
                      imageUrl:
                          character.image!,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ))),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          SlideInRight(
            delay: Duration(milliseconds: 200),
            child: Card(
                child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Name: ',
                        style: TextStyle(
                            fontSize: textTheme.titleLarge!.fontSize,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                            color: colors.primary),
                      ),
                      Text(
                        character.name!,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontSize: textTheme.titleLarge!.fontSize),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Row(
                    children: [
                      Text(
                        'Status: ',
                        style: TextStyle(
                            fontSize: textTheme.titleLarge!.fontSize,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: colors.primary),
                      ),
                      Text(
                        parseStatus(character.status!),
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontSize: textTheme.titleLarge!.fontSize),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Row(
                    children: [
                      Text(
                        'Species: ',
                        style: TextStyle(
                            fontSize: textTheme.titleLarge!.fontSize,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: colors.primary),
                      ),
                      Text(
                        parseSpecies(character.species!),
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontSize: textTheme.titleLarge!.fontSize),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Row(
                    children: [
                      Text(
                        'Gender: ',
                        style: TextStyle(
                            fontSize: textTheme.titleLarge!.fontSize,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: colors.primary),
                      ),
                      Text(
                        parseGender(character.gender!),
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontSize: textTheme.titleLarge!.fontSize),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Row(
                    children: [
                      Text(
                        'Origin: ',
                        style: TextStyle(
                            fontSize: textTheme.titleLarge!.fontSize,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: colors.primary),
                      ),
                      Text(
                        parseLocation(character.origin!),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style:
                            TextStyle(fontSize: textTheme.titleLarge!.fontSize),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Row(
                    children: [
                      Text(
                        'Location: ',
                        style: TextStyle(
                            fontSize: textTheme.titleLarge!.fontSize,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            color: colors.primary),
                      ),
                      Text(
                        parseLocation(character.location!),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style:
                            TextStyle(fontSize: textTheme.titleLarge!.fontSize),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                ],
              ),
            )),
          ),
          // Add more fields as needed
        ],
      ),
    );
  }
}
