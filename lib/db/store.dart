import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class store {
  static final tableStore = 'stores';
  static final columnCode = 'store_code';
  static final columnName = 'store_name';
  store.privateConstructor();
  static final store instance = store.privateConstructor();

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
    final path = join(documentsDirectory, 'my_project.db');
    return await openDatabase(
      path,
      version: 3,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _upgradeDatabase(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      CREATE TABLE $tableStore (
        store_id INTEGER PRIMARY  KEY AUTOINCREMENT,
        $columnCode TEXT NOT NULL,
        $columnName TEXT NOT NULL
      )
    ''');
    }
  }

  // Future<void> _onCreate(Database db, int version) async {
  //   await db.execute('''
  //     CREATE TABLE $tableStore (
  //       store_id INTEGER PRIMARY  KEY AUTOINCREMENT,
  //       $columnCode TEXT NOT NULL,
  //       $columnName TEXT NOT NULL
  //     )
  //   ''');
  // }

  Future<int> insertStore(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(tableStore, row);
  }

  Future<List<Map<String, dynamic>>> queryAllStore() async {
    final db = await instance.database;
    return await db.query(tableStore);
  }

  Future<int> updateStore(Map<String, dynamic> row) async {
    final db = await instance.database;
    final storeId = row['store_id'];
    return await db.update(
      tableStore,
      row,
      where: 'store_id = ?',
      whereArgs: [storeId],
    );
  }

  Future<int> deleteStore(int storeId) async {
    final db = await instance.database;
    return await db.delete(
      tableStore,
      where: 'store_id = ?',
      whereArgs: [storeId],
    );
  }
}
