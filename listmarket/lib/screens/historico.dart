import 'package:flutter/material.dart';
import '../services/banco_dados.dart';
import '../models/produto.dart';

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
        backgroundColor: Color.fromARGB(255, 243, 248, 255), 
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: _selecionarData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Os itens excluídos são:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: _historico.isEmpty
                  ? Text('Nenhum histórico para a data selecionada.')
                  : ListView.builder(
                      itemCount: _historico.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: index % 2 == 0 ? Color.fromARGB(255, 241, 210, 250) : Colors.white, 
                          child: ListTile(
                            title: Text(_historico[index].nome),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
