import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Database instance കിട്ടാൻ
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  // Database initialize ചെയ്യാൻ
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); // database folder path
    final path = join(dbPath, filePath); // tasks.db path
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Table create ചെയ്യാൻ
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        isCompleted INTEGER NOT NULL
      )
    ''');
  }

  // -------- CRUD Operations --------

  // Create
  Future<int> insertTask(Task task) async {
    final db = await instance.database;
    return await db.insert('tasks', task.toMap());
  }

  // Read all
  Future<List<Task>> getAllTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks');
    return result.map((map) => Task.fromMap(map)).toList();
  }

  // Update
  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Delete
  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close DB
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
