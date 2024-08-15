import 'package:flutter/material.dart';
import '../models/produto.dart';

class ListaProdutos extends StatelessWidget {
  final List<Produto> produtos;
  final Key? chave;
  final Function(Produto) aoExcluir;

  ListaProdutos({required this.produtos, this.chave, required this.aoExcluir}) : super(key: chave);

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      onReorder: (int indiceAntigo, int indiceNovo) {
        if (indiceNovo > indiceAntigo) {
          indiceNovo -= 1;
        }
        final Produto item = produtos.removeAt(indiceAntigo);
        produtos.insert(indiceNovo, item);
      },
      children: [
        for (int i = 0; i < produtos.length; i++)
          Dismissible(
            key: ValueKey(produtos[i].id),
            background: Container(color: Colors.red, child: Icon(Icons.delete, color: Colors.white)),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              aoExcluir(produtos[i]);
            },
            child: Container(
              color: i % 2 == 0 ? Color.fromARGB(255, 241, 210, 250) : Colors.white,
              child: ListTile(
                title: Text(produtos[i].nome),
              ),
            ),
          ),
      ],
    );
  }
}
