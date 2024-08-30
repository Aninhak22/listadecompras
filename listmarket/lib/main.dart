import 'package:flutter/material.dart';
import 'package:listmarket/screens/historico.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'screens/tela_inicial.dart';
import 'package:sqflite/sqflite.dart'; 
import 'package:sqlite3/sqlite3.dart';
import 'dart:io'; 

// void main() {
//   sqfliteFfiInit();
//   runApp(MeuApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();  
  }
  databaseFactory = databaseFactoryFfi;

  runApp(MeuApp());
}

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListMarket',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TelaInicial(),
      routes: {
        '/historico': (context) => TelaHistorico(),
      },
      debugShowCheckedModeBanner: false
    );
  }
}