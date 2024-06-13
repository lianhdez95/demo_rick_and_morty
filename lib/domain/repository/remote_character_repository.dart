
import '../../data/models/character_response_model.dart';

abstract class CharacterRepository {
  Future<List<Character>> getCharacters({required int page});
  Future<Character> getCharacter(int id);
}