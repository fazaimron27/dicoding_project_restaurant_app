import 'package:sqflite/sqflite.dart';
import 'package:dicoding_project_restaurant_app/data/models/restaurant.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tableName = 'favorites';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/restaurantapp.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tableName (
          id TEXT PRIMARY KEY,
          name TEXT,
          description TEXT,
          pictureId TEXT,
          city TEXT,
          rating REAL
        )''');
      },
      version: 1,
    );

    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();

    return _database;
  }

  Future<void> insertFavorite(Restaurant restaurant) async {
    final db = await database;
    await db?.insert(_tableName, restaurant.toJson());
  }

  Future<void> deleteFavorite(String id) async {
    final db = await database;
    await db?.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Restaurant>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tableName);

    return results.map((res) => Restaurant.fromJson(res)).toList();
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return results.isNotEmpty;
  }
}
