import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../models/produto.dart';

class BancoDados {
  static final BancoDados instance = BancoDados._init();
  static Database? _database;

  BancoDados._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('produtos.db');
    return _database!;
  }

  Future<Database> _initDB(String caminhoArquivo) async {
    final caminhoDb = await databaseFactoryFfi.getDatabasesPath();
    final caminho = join(caminhoDb, caminhoArquivo);

    return await databaseFactoryFfi.openDatabase(
      caminho,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _criarDB,
      ),
    );
  }

  Future _criarDB(Database db, int versao) async {
    const tipoId = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const tipoTexto = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE produtos ( 
  id $tipoId, 
  name $tipoTexto
  )
''');
  }

  Future<void> inserirProduto(Produto produto) async {
    final db = await instance.database;
    await db.insert('produtos', produto.toMap());
  }

  Future<List<Produto>> obterProdutos() async {
    final db = await instance.database;

    final resultado = await db.query('produtos');

    return resultado.map((json) => Produto.fromMap(json)).toList();
  }

  Future<void> excluirProduto(int id) async {
    final db = await instance.database;
    await db.delete('produtos', where: 'id = ?', whereArgs: [id]);
  }

  getProduto() {}

  deleteProduto(int i) {}
}
