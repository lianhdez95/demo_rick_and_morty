import '../../data/models/character_response_model.dart';

abstract class LocalCharacterDatasource {
  Future<List<Character>> searchCharacters(String query, int page);
}