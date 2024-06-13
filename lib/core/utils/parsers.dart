

import 'package:demo_rick_and_morty/data/models/character_response_model.dart';

String parseGender(Gender gender) {
  switch (gender) {
    case Gender.FEMALE:
      return 'Female';
    case Gender.MALE:
      return 'Male';
    case Gender.UNKNOWN:
    default:
      return 'unknown';
  }
}

String parseSpecies(Species species) {
  switch (species) {
    case Species.ALIEN:
      return 'Alien';
    case Species.HUMAN:
      return 'Human';
    case Species.UNKNOWN:
    default:
      return 'unknown';
  }
}

String parseStatus(Status status) {
  switch (status) {
    case Status.ALIVE:
      return 'Alive';
    case Status.DEAD:
      return 'Dead';
    case Status.UNKNOWN:
    default:
      return 'unknown';
  }
}

String parseLocation(Location location) {
  return location.name ?? '';
}