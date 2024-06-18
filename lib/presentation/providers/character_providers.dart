import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/local_characterdb_datasource_impl.dart';
import '../../data/datasource/remote_characterdb_datasource_impl.dart';
import '../../domain/models/character_response_model.dart';
import '../../data/repository/local_characterdb_repository_impl.dart';
import '../../data/repository/remote_character_repository_impl.dart';
import '../../domain/datasource/local_character_datasource.dart';
import '../../domain/datasource/remote_character_datasource.dart';
import '../../domain/repository/local_character_repository.dart';
import '../../domain/repository/remote_character_repository.dart';

//remotos
final remoteCharacterDataSourceProvider = Provider<CharacterDataSource>((ref) {
  return CharacterDataSourceImpl();
});

final remoteCharacterRepositoryProvider = Provider<CharacterRepository>((ref) {
  return CharacterRepositoryImpl(
      dataSource: ref.read(remoteCharacterDataSourceProvider));
});

//locales
final localCharacterRepositoryProvider =
    Provider<LocalCharacterRepository>((ref) {
  return LocalCharacterdbRepositoryImpl(
    localCharacterDatasource: ref.read(localCharacterDatasourceProvider),
  );
});
final localCharacterDatasourceProvider =
    Provider<LocalCharacterDatasource>((ref) {
  return LocalCharacterdbDatasourceImpl(
    remoteDataSource: ref.read(remoteCharacterDataSourceProvider),
  );
});

//filtrar personajes por nombre
final characterSearchProvider = FutureProvider.autoDispose
    .family<List<Character>, String>((ref, name) async {
  final characterRepo = ref.watch(remoteCharacterRepositoryProvider);
  try {
    return await characterRepo
        .filterCharactersByName(name)
        .timeout(const Duration(seconds: 30));
  } on TimeoutException catch (_) {
    throw Exception('La carga de datos excedió el tiempo límite');
  }
});

//un solo personaje
final characterDetailProvider = FutureProvider.autoDispose
    .family<Character, String>((ref, characterId) async {
  final characterRepo = ref.watch(remoteCharacterRepositoryProvider);
  if (int.tryParse(characterId) != null) {
    try {
      return await characterRepo
          .getCharacter(int.parse(characterId))
          .timeout(const Duration(seconds: 30));
    } on TimeoutException catch (_) {
      throw Exception('La carga de datos excedió el tiempo límite');
    }
  } else {
    throw Exception('Invalid character ID');
  }
});
// final characterListProvider = FutureProvider.autoDispose.family<List<Character>, int>((ref, page) async {
//   final characterDataSource = ref.watch(characterDataSourceProvider);
//   return characterDataSource.getCharacters(page: page);
// });

final characterListProvider =
    StateNotifierProvider<CharacterListNotifier, List<Character>>((ref) {
  return CharacterListNotifier(
    characterRepository: ref.read(localCharacterRepositoryProvider),
  );
});

class CharacterListNotifier extends StateNotifier<List<Character>> {
  CharacterListNotifier({required this.characterRepository}) : super([]);
  final LocalCharacterRepository characterRepository;
  int _currentPage = 1;
  bool isLoading = false;

  Future<void> loadInitialData() async {
    if (state.isEmpty) {
      await getNextPage();
    }
  }

  Future<void> resetAndLoadInitialData() async {
    _currentPage = 1;
    state = [];
    await loadInitialData();
  }

  Future<void> getNextPage() async {
    if (isLoading) return;
    isLoading = true;
    final newCharacters =
        await characterRepository.searchCharacters("", _currentPage);
    if (newCharacters.isNotEmpty) {
      _currentPage++;
      state = [...state, ...newCharacters];
    }
    isLoading = false;
  }
}
