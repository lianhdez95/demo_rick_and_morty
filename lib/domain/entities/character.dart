import 'package:demo_rick_and_morty/domain/entities/location.dart';

class Character {
    final int? id;
    final String? name;
    final String? status;
    final String? species;
    final String? type;
    final String? gender;
    final Location? origin;
    final Location? location;
    final String? image;
    final List<String>? episode;
    final String? url;
    final DateTime? created;

    Character({
        this.id,
        this.name,
        this.status,
        this.species,
        this.type,
        this.gender,
        this.origin,
        this.location,
        this.image,
        this.episode,
        this.url,
        this.created,
    });
  }