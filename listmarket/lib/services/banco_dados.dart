import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../models/produto.dart';

class BancoDados {
  static final BancoDados instancia = BancoDados._init();
  static Database? _database;

  BancoDados._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('produtos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await databaseFactoryFfi.getDatabasesPath();
    final path = join(dbPath, filePath);

    return await databaseFactoryFfi.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _createDB,
      ),
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE produtos ( 
  id $idType, 
  nome $textType
  )
''');
  }

  Future<void> inserirProduto(Produto produto) async {
    final db = await instancia.database;
    await db.insert('produtos', produto.toMap());
  }

  Future<List<Produto>> getProdutos() async {
    final db = await instancia.database;

    final result = await db.query('produtos');

    return result.map((json) => Produto.fromMap(json)).toList();
  }
}
