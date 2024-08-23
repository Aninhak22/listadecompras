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
        version: 2, 
        onCreate: _criarDB,
        onUpgrade: _atualizarDB,
      ),
    );
  }

  Future _criarDB(Database db, int versao) async {
    const tipoId = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const tipoTexto = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE produtos (
        id $tipoId,
        nome $tipoTexto
      )
    ''');

    await db.execute('''
      CREATE TABLE historico (
        id $tipoId,
        nome $tipoTexto,
        data TEXT NOT NULL
      )
    ''');
  }

  Future _atualizarDB(Database db, int antigo, int novo) async {
    if (antigo < 2) {
      await db.execute('''
        CREATE TABLE historico (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          data TEXT NOT NULL
        )
      ''');
    }
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
    

    final produto = await db.query('produtos', where: 'id = ?', whereArgs: [id]);
    if (produto.isNotEmpty) {
     
      await db.insert('historico', {
        'id': produto.first['id'],
        'nome': produto.first['nome'],
        'data': DateTime.now().toIso8601String(),
      });
    }

    
    await db.delete('produtos', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Produto>> obterHistorico(DateTime data) async {
    final db = await instance.database;
    final dataFormatada = data.toIso8601String().split('T')[0]; 
    final resultado = await db.query(
      'historico',
      where: 'data LIKE ?',
      whereArgs: ['$dataFormatada%'],
    );
    return resultado.map((json) => Produto.fromMap(json)).toList();
  }
}