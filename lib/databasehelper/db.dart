import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/category.dart';
import '../models/event.dart';
import '../models/note.dart';
import '../models/task.dart';
import '../models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'app_database.db'),
      version: 2, // Increment the version number
      onCreate: _createTables,
      onUpgrade: _upgradeTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE category (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color TEXT NOT NULL,
        createdDate TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE event (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        dateTime TEXT NOT NULL,
        categoryId INTEGER NOT NULL,
        description TEXT,
        isCompleted INTEGER NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES category (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE note (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdDate TEXT NOT NULL,
        taskId INTEGER,
        imagePath TEXT,
        FOREIGN KEY (taskId) REFERENCES task (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE task (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        deadline TEXT NOT NULL,
        categoryId INTEGER NOT NULL,
        priority INTEGER NOT NULL,
        isCompleted INTEGER NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES category (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        avatarUrl TEXT,
        createdDate TEXT NOT NULL
      )
    ''');
  }

  Future<void> _upgradeTables(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
          'ALTER TABLE task ADD COLUMN isCompleted INTEGER NOT NULL DEFAULT 0');
    }
  }

  Future<int> insertCategory(Category category) async {
    final db = await database;
    return await db.insert('category', category.toMap());
  }

  // Read all categories
  Future<List<Category>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('category');
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  // Update an existing category
  Future<int> updateCategory(Category category) async {
    final db = await database;
    return await db.update(
      'category',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  // Delete a category
  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete(
      'category',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertEvent(Event event) async {
    final db = await database;
    return await db.insert('event', event.toMap());
  }

  // Read all events
  Future<List<Event>> getEvents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('event');
    return List.generate(maps.length, (i) {
      return Event.fromMap(maps[i]);
    });
  }

  // Update an existing event
  Future<int> updateEvent(Event event) async {
    final db = await database;
    return await db.update(
      'event',
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  // Delete an event
  Future<int> deleteEvent(int id) async {
    final db = await database;
    return await db.delete(
      'event',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert('note', note.toMap());
  }

  // Read all notes
  Future<List<Note>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('note');
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  // Update an existing note
  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'note',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Delete a note
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      'note',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Create a new user
  Future<int> insertUser(User user, String password) async {
    final db = await database;
    return await db.insert('user', {
      ...user.toMap(),
      'password': password,
    });
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Authenticate user
  Future<User?> authenticateUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('task', task.toMap());
  }

  // Read all tasks
  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('task');
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  // Update an existing task
  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'task',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Delete a task
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'task',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
