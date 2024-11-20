import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static final _databaseName = "UserDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'user_table';

  // Kolom yang ada di tabel
  static final columnId = '_id';
  static final columnUsername = 'username';
  static final columnPassword = 'password';

  // Membuat singleton database helper
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Membuat tabel
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnUsername TEXT NOT NULL,
            $columnPassword TEXT NOT NULL
          )
          ''');
  }

Future<int> createUser(String username, String password) async {
  Database db = await instance.database;

  // Cek apakah username sudah ada
  List<Map<String, Object?>> result = await db.query(
    table,
    where: '$columnUsername = ?',
    whereArgs: [username],
  );

  if (result.isNotEmpty) {
    // Jika username sudah ada, lempar error
    throw Exception('Username already exists!');
  }

  // Jika username belum ada, tambahkan user baru
  int id = await db.insert(
    table,
    {columnUsername: username, columnPassword: password},
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  return id; // Mengembalikan id yang baru dimasukkan
}


  // Fungsi untuk login dan memverifikasi username dan password
  Future<Map<String, dynamic>?> login(String username, String password) async {
    Database db = await instance.database;
    var result = await db.query(
      table,
      where: '$columnUsername = ? AND $columnPassword = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}
