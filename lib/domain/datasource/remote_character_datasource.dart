
import '../models/character_response_model.dart';

abstract class CharacterDataSource {
  Future<List<Character>> getCharacters({required int page});
  Future<Character> getCharacter(int id);
  Future<List<Character>> filterCharactersByName(String name);
  Future<int> getAllPages();
}