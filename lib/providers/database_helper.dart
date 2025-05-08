import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:trakli/models/transaction_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        amount REAL,
        description TEXT,
        createdAt TEXT,
        updatedAt TEXT,
        deletedAt TEXT,
        lastSyncedAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE sync_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        modelName TEXT,
        operation TEXT,
        data TEXT,
        createdAt TEXT
      )
    ''');
  }

  Future<void> insertTransaction(TransactionModel tx) async {
    final dbClient = await db;
    await dbClient.insert('transactions', tx.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    await enqueueSync('Transaction', 'create', tx.toJson());
  }

  Future<void> updateTransaction(TransactionModel tx) async {
    final dbClient = await db;
    await dbClient.update(
      'transactions',
      tx.toMap(),
      where: 'id = ?',
      whereArgs: [tx.id],
    );

    await enqueueSync('Transaction', 'update', tx.toJson());
  }

  Future<void> deleteTransaction(String id) async {
    final dbClient = await db;
    await dbClient.update(
      'transactions',
      {
        'deletedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    await enqueueSync('Transaction', 'delete', {'id': id});
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final dbClient = await db;

    final maps = await dbClient.query(
      'transactions',
      where: 'deletedAt IS NULL', // Optional: skip soft-deleted ones
      orderBy: 'createdAt DESC', // Optional: most recent first
    );

    return maps.map((map) => TransactionModel.fromMap(map)).toList();
  }

  Future<void> enqueueSync(
      String model, String operation, Map<String, dynamic> data) async {
    final dbClient = await db;
    await dbClient.insert('sync_queue', {
      'modelName': model,
      'operation': operation,
      'data': data.toString(), // optionally jsonEncode
      'createdAt': DateTime.now().toIso8601String(),
    });
  }
}
