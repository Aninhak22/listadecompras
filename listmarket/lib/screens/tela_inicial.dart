import 'package:flutter/material.dart';
import '../models/produto.dart'; 
import '../services/banco_dados.dart'; 
import '../widgets/produto_lista.dart'; 

class TelaInicial extends StatefulWidget {
  final Key? key;

  TelaInicial({this.key}) : super(key: key);

  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  List<Produto> produtos = [];

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    final dados = await BancoDados.instancia.getProdutos();
    setState(() {
      produtos = dados;
    });
  }

  Future<void> _adicionarProduto(String nome) async {
    final novoProduto = Produto(nome: nome);
    await BancoDados.instancia.inserirProduto(novoProduto);
    _carregarProdutos();
  }

  void _mostrarDialogoAdicionarProduto() {
    final _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Produto'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'Nome do Produto'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cadastrar'),
              onPressed: () {
                final nome = _nameController.text;
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
      body: Center(
        child: ListaDeProdutos(produtos: produtos),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoAdicionarProduto,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

