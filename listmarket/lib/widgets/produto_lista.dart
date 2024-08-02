import 'package:flutter/material.dart';
import '../models/produto.dart';

class ListaDeProdutos extends StatelessWidget {
  final List<Produto> produtos;
  final Key? key;

  ListaDeProdutos({required this.produtos, this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      onReorder: (int oldIndex, int newIndex) {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final Produto item = produtos.removeAt(oldIndex);
        produtos.insert(newIndex, item);
      },
      children: [
        for (final produto in produtos)
          ListTile(
            key: ValueKey(produto.id),
            title: Text(produto.nome),
          ),
      ],
    );
  }
}

