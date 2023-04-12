import 'package:inventoryapp/imported/Class/product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart';

class DatabaseHelper {
  DatabaseHelper.privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();
  static final _databaseName = "my_project.db";
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, _databaseName);

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      print("Creating new copy from asset");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets", _databaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }

    return await openDatabase(path, readOnly: false);
  }
  // Future<Database> initDatabase() async {
  //   var databasesPath = await getDatabasesPath();
  //   var path = join(databasesPath, "sqlite_database2.db");
  //   var exists = await databaseExists(path);
  //   if (!exists) {
  //     print("Creating new copy from asset");
  //     try {
  //       await Directory(dirname(path)).create(recursive: true);
  //     } catch (_) {}
  //     ByteData data = await rootBundle.load('assets/my_project.db');
  //     List<int> bytes =
  //         data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  //     await File(path).writeAsBytes(bytes, flush: true);
  //   } else {
  //     print("Opening existing database");
  //   }
  //   return await openDatabase(path, readOnly: true);
  // }

  static final tableUsers = 'users';
  static final columnUserId = 'user_id';
  static final columnStoreId = 'store_id';
  static final columnEmail = 'username';
  static final columnPassword = 'password';

  Future<int> insertUser(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(tableUsers, row);
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

  static final tableStore = 'stores';
  static final columnCode = 'store_code';
  static final columnName = 'store_name';

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

  static final tableProducts = 'products';
  static final columnProductId = "product_id";
  static final columnProductName = 'product_name';
  static final columnProductimage = 'product_image';
  static final columnProductCode = "product_code";
  static final columnProductDetail = "product_detail";

  Future<int> insertProduct(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(tableProducts, row);
  }

  Future<List<Product>>  queryAllProduct() async {
    final db = await instance.database;
    final query =  await db.query(tableProducts);
    print(query);
    List<Product> products = query.map((productMap) {
      return Product(
        product_image: productMap['product_image'].toString(),
        product_name: productMap['product_name'].toString(),
      );
    }).toList();
    return products;
  }

  Future<List<Product>> getProductsAndSubProducts(int storeId) async {
    Database db = await database;
    final productMaps = await db.rawQuery('''
    SELECT product_image , product_name FROM products
    INNER JOIN sub_products ON products.product_id = sub_products.product_id
    WHERE products.store_id = ?
  ''', [storeId]);
    List<Product> products = productMaps.map((productMap) {
      return Product(
        product_image: productMap['product_image'].toString(),
        product_name: productMap['product_name'].toString(),
      );
    }).toList();
    return products;
  }

  Future<int> updateProduct(Map<String, dynamic> row) async {
    final db = await instance.database;
    final productId = row['product_id'];
    return await db.update(
      tableProducts,
      row,
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  Future<int> deleteProduct(int productId) async {
    final db = await instance.database;
    return await db.delete(
      tableProducts,
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  static final tableSubProducts = "sub_products";
  static final columnSubProductName = "sub_product_name";
  static final columnSubProductCost = "sub_product_cost";
  static final columnSubProductPrice = "sub_product_price";
  static final columnSubProductQuantity = "sub_product_quantity";

  Future<int> insertSubProducts(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(tableSubProducts, row);
  }

  Future<List<Map<String, dynamic>>> queryAllSubProducts() async {
    final db = await instance.database;
    return await db.query(tableSubProducts);
  }

  Future<int> updateSubProducts(Map<String, dynamic> row) async {
    final db = await instance.database;
    final subId = row['sub_id'];
    return await db.update(
      tableSubProducts,
      row,
      where: 'sub_id = ?',
      whereArgs: [subId],
    );
  }

  Future<int> deleteSubProducts(int subId) async {
    final db = await instance.database;
    return await db.delete(
      tableProducts,
      where: 'sub_id = ?',
      whereArgs: [subId],
    );
  }
}
