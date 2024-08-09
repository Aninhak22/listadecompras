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
        for (final produto in produtos)
          Dismissible(
            key: ValueKey(produto.id),
            background: Container(color: Colors.red, child: Icon(Icons.delete, color: Colors.white)),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              aoExcluir(produto);
            },
            child: ListTile(
              title: Text(produto.nome),
            ),
          ),
      ],
    );
  }
}
