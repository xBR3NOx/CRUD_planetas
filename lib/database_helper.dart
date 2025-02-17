import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('planetas.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE planetas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        distancia REAL NOT NULL,
        tamanho INTEGER NOT NULL,
        apelido TEXT
      )
    ''');
  }

  Future<int> inserirPlaneta(Map<String, dynamic> planeta) async {
    final db = await instance.database;
    return await db.insert('planetas', planeta);
  }

  Future<List<Map<String, dynamic>>> listarPlanetas() async {
    final db = await instance.database;
    return await db.query('planetas');
  }

  Future<int> atualizarPlaneta(int id, Map<String, dynamic> planeta) async {
    final db = await instance.database;
    return await db.update('planetas', planeta, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> excluirPlaneta(int id) async {
    final db = await instance.database;
    return await db.delete('planetas', where: 'id = ?', whereArgs: [id]);
  }
}
