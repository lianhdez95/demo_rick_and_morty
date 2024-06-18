// import 'dart:convert';
// import 'package:demo_rick_and_morty/domain/models/character_response_model.dart';
// import 'package:demo_rick_and_morty/domain/datasource/local_character_datasource.dart';
// import 'package:demo_rick_and_morty/domain/datasource/remote_character_datasource.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LocalCharacterdbDatasourceImpl implements LocalCharacterDatasource{
//   final CharacterDataSource remoteDataSource;

//   LocalCharacterdbDatasourceImpl({required this.remoteDataSource});

//   @override
//   Future<List<Character>> searchCharacters(String query, int page) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (prefs.containsKey('characters')) {
//       Map<String, dynamic> loadedData = jsonDecode(prefs.getString('characters')!);
//       if (loadedData.containsKey(page.toString())) {
//         List<Character> loadedCharacters = (loadedData[page.toString()] as List)
//             .map((i) => Character.fromJson(i)).toList();
//         return loadedCharacters.where((character) => character.name!.contains(query)).toList();
//       } else {
//         // Utiliza el datasource remoto para hacer la solicitud a la API
//         List<Character> characters = await remoteDataSource.getCharacters(page: page);
//         // Almacena los datos y luego devuélvelos
//         storeCharacters(page, characters);
//         return characters;
//       }
//     } else {
//       // Si no hay datos almacenados, utiliza el datasource remoto para hacer la solicitud a la API
//       List<Character> characters = await remoteDataSource.getCharacters(page: page);
//       // Almacena los datos y luego devuélvelos
//       storeCharacters(page, characters);
//       return characters;
//     }
//   }

//   Future<void> storeCharacters(int page, List<Character> characters) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     Map<String, dynamic> storedData = prefs.containsKey('characters') ? jsonDecode(prefs.getString('characters')!) : {};
//     storedData[page.toString()] = characters.map((i) => i.toJson()).toList();
//     prefs.setString('characters', jsonEncode(storedData));
//   }
  
//   @override
//   Future<List<Character>> loadAllCharacters() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<Character> allCharacters = [];

//     if (prefs.containsKey('characters')) {
//       Map<String, dynamic> loadedData = jsonDecode(prefs.getString('characters')!);
//       loadedData.forEach((page, charactersData) {
//         List<Character> loadedCharacters = (charactersData as List)
//             .map((i) => Character.fromJson(i)).toList();
//         allCharacters.addAll(loadedCharacters);
//       });
//     }

//     return allCharacters;
//   }
// }