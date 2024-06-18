
import 'package:dio/dio.dart';

import '../../domain/datasource/remote_character_datasource.dart';
import '../../domain/models/character_response_model.dart';

class CharacterDataSourceImpl implements CharacterDataSource {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://rickandmortyapi.com/api',
  ));

  @override
  Future<List<Character>> getCharacters({int page = 1}) {
    return dio.get('/character', queryParameters: {'page': page}).then(
        (value) => (value.data['results'] as List)
            .map((e) => Character.fromJson(e))
            .toList());
  }

  @override
  Future<Character> getCharacter(int id) async {
    final response = await dio.get('/character/$id');
    if (response.statusCode == 200) {
      return Character.fromJson(response.data);
    } else {
      throw Exception('Failed to load character');
    }
  }

  @override
  Future<List<Character>> filterCharactersByName(String name) {
    return dio
        .get('/character', queryParameters: {'name': name})
        .then((value) => (value.data['results'] as List)
            .map((e) => Character.fromJson(e))
            .toList());
  }
}
