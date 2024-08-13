// tela_inicial.dart
import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/banco_dados.dart';
import '../widgets/produto_lista.dart';

class TelaInicial extends StatefulWidget {
  final Key? chave;

  TelaInicial({this.chave}) : super(key: chave);

  @override
  _TelaInicialEstado createState() => _TelaInicialEstado();
}

class _TelaInicialEstado extends State<TelaInicial> {
  List<Produto> produtos = [];

  @override
  void initState() {
    super.initState();
    _carregarProdutos(); // Carrega os produtos ao iniciar a tela
  }

  Future<void> _carregarProdutos() async {
    final dados = await BancoDados.instance.obterProdutos();
    setState(() {
      produtos = dados;
    });
  }

  Future<void> _adicionarProduto(String nome) async {
    final novoProduto = Produto(nome: nome);
    await BancoDados.instance.inserirProduto(novoProduto);
    _carregarProdutos(); // Recarrega os produtos após adicionar um novo
  }

  Future<void> _excluirProduto(Produto produto) async {
    await BancoDados.instance.excluirProduto(produto.id!);
    _carregarProdutos(); // Recarrega os produtos após excluir
  }

  void _mostrarDialogoAdicionarProduto() {
    final _controladorNome = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Produto'),
          content: TextField(
            controller: _controladorNome,
            decoration: InputDecoration(hintText: 'Nome do Produto'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cadastrar'),
              onPressed: () {
                final nome = _controladorNome.text;
                if (nome.isNotEmpty) {
                  _adicionarProduto(nome);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag),
            SizedBox(width: 10),
            Text('ListMarket'),
          ],
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Consultar histórico'),
              onTap: () {
                Navigator.of(context).pop(); // Fecha o menu lateral
                Navigator.of(context).pushNamed('/historico'); // Navega para a tela de histórico
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: produtos.isEmpty
            ? Text('Nenhum produto cadastrado')
            : ListaProdutos(
                produtos: produtos,
                aoExcluir: (produto) {
                  _excluirProduto(produto);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoAdicionarProduto,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
