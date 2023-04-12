import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class auth {
  static final _databaseName = 'my_project.db';
  static final _databaseVersion = 1;

  static final tableUsers = 'users';

  static final columnUserId = 'user_id';
  static final columnStoreId = 'store_id';
  static final columnEmail = 'email';
  static final columnPassword = 'password';

  auth.privateConstructor();
  static final auth instance = auth.privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableUsers (
        $columnUserId INTEGER PRIMARY KEY,
        $columnStoreId INTEGER NOT NULL,
        $columnEmail TEXT NOT NULL,
        $columnPassword TEXT NOT NULL,
        FOREIGN KEY ($columnStoreId) REFERENCES stores(store_id)
      )
    ''');
  }

  Future<int> insertUser(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(tableUsers,row);
  }

  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    final db = await instance.database;
    return await db.query(tableUsers);
  }

  Future<int> updateUser(Map<String, dynamic> row) async {
    final db = await instance.database;
    final userId = row[columnUserId];
    return await db.update(
      tableUsers,
      row,
      where: '$columnUserId = ?',
      whereArgs: [userId],
    );
  }

  Future<int> deleteUser(int userId) async {
    final db = await instance.database;
    return await db.delete(
      tableUsers,
      where: '$columnUserId = ?',
      whereArgs: [userId],
    );
  }
}
