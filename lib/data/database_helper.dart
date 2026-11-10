import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/food_spot.dart';

/// Singleton that owns the single SQLite connection of the app.
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// Returns the open database, opening it on first use.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('food_spots.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE food_spots (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        review TEXT NOT NULL,
        image_path TEXT,
        latitude REAL,
        longitude REAL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  /// Saves a new food spot and returns its generated id.
  Future<int> insertSpot(FoodSpot spot) async {
    final db = await instance.database;
    return await db.insert(
      'food_spots',
      spot.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Returns all food spots, newest first.
  Future<List<FoodSpot>> getSpots() async {
    final db = await instance.database;
    final rows = await db.query('food_spots', orderBy: 'id DESC');
    return rows.map((row) => FoodSpot.fromMap(row)).toList();
  }
}
