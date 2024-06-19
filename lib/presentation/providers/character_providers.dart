import 'dart:developer';

import 'package:demo_rick_and_morty/core/errors/no_more_pages_exception.dart';
import 'package:demo_rick_and_morty/data/datasource/local_characterdb_datasource_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/remote_characterdb_datasource_impl.dart';
import '../../data/repository/local_characterdb_repository_impl.dart';
import '../../data/repository/remote_character_repository_impl.dart';
import '../../domain/datasource/local_character_datasource.dart';
import '../../domain/datasource/remote_character_datasource.dart';
import '../../domain/models/character_response_model.dart';
import '../../domain/repository/local_character_repository.dart';
import '../../domain/repository/remote_character_repository.dart';

final characterDataSourceProvider = Provider<CharacterDataSource>((ref) {
  return CharacterDataSourceImpl();
});

final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  return CharacterRepositoryImpl(
      dataSource: ref.read(characterDataSourceProvider));
});

final totalPagesProvider = FutureProvider<int>((ref) async {
  final characterRepo = ref.watch(characterRepositoryProvider);
  return await characterRepo.getAllPages();
});

final localCharacterDatasourceProvider =
    Provider<LocalCharacterDatasource>((ref) {
  return LocalCharacterDbDatasourceImpl();
});

final localCharacterRepositoryProvider =
    Provider<LocalCharacterRepository>((ref) {
  return LocalCharacterdbRepositoryImpl(
      localCharacterDatasource: ref.read(localCharacterDatasourceProvider));
});

//remoto, para las búsquedas
final characterDetailProvider = FutureProvider.autoDispose
    .family<Character, String>((ref, characterId) async {
  final characterRepo = ref.watch(characterRepositoryProvider);
  if (int.tryParse(characterId) != null) {
    return await characterRepo.getCharacter(int.parse(characterId));
  } else {
    throw Exception('Invalid character ID');
  }
});

//local, para los detalles
final characterLocalDetailProvider = FutureProvider.autoDispose
    .family<Character, String>((ref, characterId) async {
  final localCharacterRepo = ref.watch(localCharacterRepositoryProvider);
  if (int.tryParse(characterId) != null) {
    return await localCharacterRepo.getCharacter(int.parse(characterId));
  } else {
    throw Exception('Invalid character ID');
  }
});
// final characterListProvider = FutureProvider.autoDispose.family<List<Character>, int>((ref, page) async {
//   final characterDataSource = ref.watch(characterDataSourceProvider);
//   return characterDataSource.getCharacters(page: page);
// });

final characterListProvider =
    StateNotifierProvider.autoDispose<CharacterListNotifier, List<Character>>(
        (ref) {
  final remoteCharacterRepository = ref.watch(characterRepositoryProvider);
  final localCharacterRepository = ref.watch(localCharacterRepositoryProvider);
  final totalPages = ref.watch(totalPagesProvider.future);

  return CharacterListNotifier(
      remoteCharacterRepository, localCharacterRepository, totalPages);
});

class CharacterListNotifier extends StateNotifier<List<Character>> {
  final CharacterRepository _remoteCharacterRepository;
  final LocalCharacterRepository _localCharacterRepository;
  final Future<int> _totalPages;
  int _currentPage = 0;
  int _residual = 0;
  bool isLoading = false;


  CharacterListNotifier(this._remoteCharacterRepository,
      this._localCharacterRepository, this._totalPages)
      : super([]);

  Future<void> loadInitialData() async {
    if (state.isEmpty) {
      // Primero intentamos cargar los datos de la base de datos local
      List<Character> characters =
          await _localCharacterRepository.getAllCharacters();

      //se incrementa el paginado en dependencia de cuántos objetos hay en la base local
      _currentPage = characters.length ~/ 20;
      _residual = characters.length % 20;


      log('Se han cargado $_currentPage páginas');
      log('Hay ${characters.length} personajes en la local' );
      log('El residual es $_residual');

      if (characters.isEmpty) {
        // Si la base de datos local está vacía, cargamos los datos de la base de datos remota
        await getNextPage();
      } else {
        // Si la base de datos local tiene datos, los usamos
        state = characters;
      }
    }
  }

  Future<void> resetAndLoadInitialData() async {
    _currentPage = 0;
    state = [];
    await loadInitialData();
  }

  Future<void> getNextPage() async {

    isLoading = true;
    // Cargamos los datos de la base de datos remota

    _currentPage++;
    log('Cargando página $_currentPage');
    if (_currentPage <= await _totalPages && _residual == 0) {
      final newCharacters =
          await _remoteCharacterRepository.getCharacters(page: _currentPage);
      if (newCharacters.isNotEmpty) {
        // Guardamos los nuevos personajes en la base de datos local
        await _localCharacterRepository.saveCharacters(newCharacters);
        // Actualizamos el estado con los nuevos personajes
        state = [...state, ...newCharacters];
      }
    } else{
      isLoading = false;
      throw NoMorePagesException();
    }

    isLoading = false;
  }
}
