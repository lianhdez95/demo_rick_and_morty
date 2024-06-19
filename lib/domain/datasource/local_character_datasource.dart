import '../models/character_response_model.dart';

abstract class LocalCharacterDatasource{
  Future<void> saveCharacters(List<Character> characters);
  Future<List<Character>> getAllCharacters();
  Future<Character> getCharacter(int id);
}