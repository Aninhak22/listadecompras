import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/banco_dados.dart';


class TelaHistorico extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Aqui está o histórico de produtos'),
      ),
    );
  }
}
