import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/remote_characterdb_datasource_impl.dart';
import '../../data/models/character_response_model.dart';
import '../../data/repository/remote_character_repository_impl.dart';
import '../../domain/datasource/remote_character_datasource.dart';
import '../../domain/repository/remote_character_repository.dart';



final characterDataSourceProvider = Provider<CharacterDataSource>((ref) {
  return CharacterDataSourceImpl();
});


final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  return CharacterRepositoryImpl(dataSource: ref.read(characterDataSourceProvider));
});

final characterDetailProvider = FutureProvider.autoDispose.family<Character, String>((ref, characterId) async {
  final characterRepo = ref.watch(characterRepositoryProvider);
  if (int.tryParse(characterId) != null) {
    return await characterRepo.getCharacter(int.parse(characterId));
  } else {
    throw Exception('Invalid character ID');
  }
});
// final characterListProvider = FutureProvider.autoDispose.family<List<Character>, int>((ref, page) async {
//   final characterDataSource = ref.watch(characterDataSourceProvider);
//   return characterDataSource.getCharacters(page: page);
// });

final characterListProvider = StateNotifierProvider.autoDispose<CharacterListNotifier, List<Character>>((ref) {
  return CharacterListNotifier(ref.watch(characterDataSourceProvider));
});

class CharacterListNotifier extends StateNotifier<List<Character>> {
  CharacterListNotifier(this._characterDataSource) : super([]);

  final CharacterDataSource _characterDataSource;
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
    final newCharacters = await _characterDataSource.getCharacters(page: _currentPage);
    if (newCharacters.isNotEmpty) {
      _currentPage++;
      state = [...state, ...newCharacters];
    }
    isLoading = false;
  }
}