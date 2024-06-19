import 'package:demo_rick_and_morty/domain/models/character_response_model.dart';
import 'package:demo_rick_and_morty/domain/repository/local_character_repository.dart';

import '../../domain/datasource/local_character_datasource.dart';

class LocalCharacterdbRepositoryImpl implements LocalCharacterRepository {
  
  final LocalCharacterDatasource localCharacterDatasource;
  LocalCharacterdbRepositoryImpl({required this.localCharacterDatasource});
  
  @override
  Future<List<Character>> getAllCharacters() {
    return localCharacterDatasource.getAllCharacters();
  }

  @override
  Future<void> saveCharacters(List<Character> characters) {
    
    return localCharacterDatasource.saveCharacters(characters);
  }
  
  @override
  Future<Character> getCharacter(int id) {
    return localCharacterDatasource.getCharacter(id);
  }
}