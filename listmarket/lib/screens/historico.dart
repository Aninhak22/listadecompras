import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/banco_dados.dart';

class TelaHistorico extends StatefulWidget {
  @override
  _TelaHistoricoEstado createState() => _TelaHistoricoEstado();
}

class _TelaHistoricoEstado extends State<TelaHistorico> {
  DateTime _dataSelecionada = DateTime.now();
  List<Produto> _historico = [];

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  Future<void> _carregarHistorico() async {
    final historico = await BancoDados.instance.obterHistorico(_dataSelecionada);
    setState(() {
      _historico = historico;
    });
  }

  void _selecionarData() async {
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (dataSelecionada != null && dataSelecionada != _dataSelecionada) {
      setState(() {
        _dataSelecionada = dataSelecionada;
      });
      _carregarHistorico();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: _selecionarData,
          ),
        ],
      ),
      body: Center(
        child: _historico.isEmpty
            ? Text('Nenhum histórico para a data selecionada.')
            : ListView(
                children: _historico.map((produto) {
                  return ListTile(
                    title: Text(produto.nome),
                  );
                }).toList(),
              ),
      ),
    );
  }
}
