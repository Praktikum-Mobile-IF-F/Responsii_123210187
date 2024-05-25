import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'kopi_data.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'kopi_database.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE favorites('
              'id TEXT PRIMARY KEY, '
              'name TEXT, '
              'description TEXT, '
              'price REAL, '
              'region TEXT, '
              'weight INTEGER, '
              'flavorProfile TEXT, '
              'grindOption TEXT, '
              'roastLevel INTEGER, '
              'imageUrl TEXT'
              ')',
        );
      },
      version: 1,
    );
  }

  Future<void> insertFavorite(JenisKopi jenisKopi) async {
    final db = await database;
    await db.insert(
      'favorites',
      jenisKopi.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }

  Future<List<JenisKopi>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return List.generate(maps.length, (i) {
      return JenisKopi.fromJson(maps[i]);
    });
  }
}
