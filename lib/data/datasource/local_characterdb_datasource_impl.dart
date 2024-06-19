import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/datasource/local_character_datasource.dart';
import '../../domain/models/character_response_model.dart';

class LocalCharacterDbDatasourceImpl implements LocalCharacterDatasource {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'character_database.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE characters(id INTEGER PRIMARY KEY, name TEXT, status TEXT, species TEXT, type TEXT, gender TEXT, origin TEXT, location TEXT, image TEXT, episode TEXT, url TEXT, created TEXT)",
        );
      },
      version: 1,
    );
  }

  @override
  Future<void> saveCharacters(List<Character> characters) async {
    final db = await database;
    Batch batch = db.batch();
    for (var character in characters) {
      batch.insert('characters', {
        'id': character.id,
        'name': character.name,
        'status': statusValues.reverse[character.status],
        'species': speciesValues.reverse[character.species],
        'type': character.type,
        'gender': genderValues.reverse[character.gender],
        'origin': character.origin?.name,
        'location': character.location?.name,
        'image': character.image,
        'episode': character.episode?.join(', '),
        'url': character.url,
        'created': character.created?.toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<Character>> getAllCharacters() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('characters');
    return List.generate(maps.length, (i) {
      var map = maps[i];
      return Character(
        id: map['id'],
        name: map['name'],
        status: statusValues.map[map['status']] ?? Status.UNKNOWN,
        species: speciesValues.map[map['species']] ?? Species.UNKNOWN,
        type: map['type'],
        gender: genderValues.map[map['gender']] ?? Gender.UNKNOWN,
        origin: Location(name: map['origin'], url: null),
        location: Location(name: map['location'], url: null),
        image: map['image'],
        episode: map['episode']?.split(', '),
        url: map['url'],
        created: map['created'] == null ? null : DateTime.parse(map['created']),
      );
    });
  }
  
  @override
  Future<Character> getCharacter(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'characters',
      where: 'id = ?',
      whereArgs: [id],
    );
  
    if (maps.isNotEmpty) {
      var map = maps.first;
      return Character(
        id: map['id'],
        name: map['name'],
        status: statusValues.map[map['status']] ?? Status.UNKNOWN,
        species: speciesValues.map[map['species']] ?? Species.UNKNOWN,
        type: map['type'],
        gender: genderValues.map[map['gender']] ?? Gender.UNKNOWN,
        origin: Location(name: map['origin'], url: null),
        location: Location(name: map['location'], url: null),
        image: map['image'],
        episode: map['episode']?.split(', '),
        url: map['url'],
        created: map['created'] == null ? null : DateTime.parse(map['created']),
      );
    } else {
      throw Exception('Character with id $id not found');
    }
  }
}