import '../entities/character.dart';

abstract class CharacterDataSource {
  Future<List<Character>> getCharacters();
}