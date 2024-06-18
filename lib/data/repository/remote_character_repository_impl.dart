import '../../domain/datasource/remote_character_datasource.dart';
import '../../domain/repository/remote_character_repository.dart';
import '../../domain/models/character_response_model.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterDataSource dataSource;

  CharacterRepositoryImpl({required this.dataSource});

  @override
  Future<List<Character>> getCharacters({required int page}) {
    return dataSource.getCharacters(page: 1);
  }
  
   @override
  Future<Character> getCharacter(int id) async {
    return await dataSource.getCharacter(id);
  }

  @override
  Future<List<Character>> filterCharactersByName(String name) {
    return dataSource.filterCharactersByName(name);
  }
}