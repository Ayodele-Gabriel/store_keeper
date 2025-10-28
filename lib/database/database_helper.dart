import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('products.db');
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
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE $tableProducts (
        ${ProductFields.id} $idType,
        ${ProductFields.name} $textType,
        ${ProductFields.quantity} $integerType,
        ${ProductFields.price} $realType,
        ${ProductFields.imagePath} TEXT,
        ${ProductFields.createdAt} $textType,
        ${ProductFields.updatedAt} $textType
      )
    ''');
  }

  Future<Product> create(Product product) async {
    final db = await instance.database;
    final id = await db.insert(tableProducts, product.toJson());
    return product.copy(id: id);
  }

  Future<Product?> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableProducts,
      columns: ProductFields.values,
      where: '${ProductFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Product.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Product>> readAllProducts() async {
    final db = await instance.database;
    const orderBy = '${ProductFields.updatedAt} DESC';
    final result = await db.query(tableProducts, orderBy: orderBy);
    return result.map((json) => Product.fromJson(json)).toList();
  }

  Future<int> update(Product product) async {
    final db = await instance.database;
    return db.update(
      tableProducts,
      product.toJson(),
      where: '${ProductFields.id} = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableProducts,
      where: '${ProductFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<Product>> searchProducts(String query) async {
    final db = await instance.database;
    final result = await db.query(
      tableProducts,
      where: '${ProductFields.name} LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: '${ProductFields.name} ASC',
    );
    return result.map((json) => Product.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}