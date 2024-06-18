
import 'package:demo_rick_and_morty/domain/models/character_response_model.dart';
import 'package:demo_rick_and_morty/domain/repository/local_character_repository.dart';

import '../../domain/datasource/local_character_datasource.dart';

class LocalCharacterdbRepositoryImpl implements LocalCharacterRepository{
  final LocalCharacterDatasource localCharacterDatasource;
  LocalCharacterdbRepositoryImpl({required this.localCharacterDatasource});
  @override
  Future<List<Character>> searchCharacters(String query, int page) {
    return localCharacterDatasource.searchCharacters(query, page);
  }
}