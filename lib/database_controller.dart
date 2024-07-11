import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "myDatabase.db";
  static const _databaseVersion = 1;

  static const table = 'interview';
  static const columnId = '_id';
  static const columnProductName = 'product_name';
  static const columnUnitNumber = 'unit_number';
  static const columnPrice = 'price';
  static const columnQuantity = 'quantity';
  static const columnTotal = 'total';
  static const columnExpiryDate = 'expiry_date';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion,
        onCreate: (db, version) {
      db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnProductName TEXT NOT NULL,
            $columnUnitNumber INTEGER NOT NULL,
            $columnPrice INTEGER NOT NULL,
            $columnQuantity INTEGER NOT NULL,
            $columnTotal INTEGER NOT NULL,
            $columnExpiryDate DATE NOT NULL
          )
          ''');
    });
  }
}
