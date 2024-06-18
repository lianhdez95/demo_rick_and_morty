import '../models/character_response_model.dart';

abstract class LocalCharacterRepository{
  Future<List<Character>> searchCharacters(String query, int page);
  Future<List<Character>> getAllCharacters();
}