import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<String> _getDatabasesPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return join(directory.path, 'new_habit.db');
  }

  Future<Database> _initDatabase() async {
    String path = await _getDatabasesPath();
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    // 在这里创建你的数据库表
    await db.execute('''
      CREATE TABLE habits (
        id INTEGER PRIMARY KEY,
        name TEXT,
        target_date INTEGER,
        start_date INTEGER
      )
    ''');
  }

  Future<void> deleteHabit(int id) async {
    final db = await database;
    await db.delete('habits', where: 'id = ?', whereArgs: [id]);
  }

}
