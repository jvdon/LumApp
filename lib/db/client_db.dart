import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lumapp/models/car.dart';
import 'package:lumapp/models/cliente.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:async';

class ClienteDB {
  Future<Database> _getDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, "lumapp.db");
    String sql = """CREATE TABLE IF NOT EXISTS clientes (
      nome TEXT PRIMARY KEY,
      CPF TEXT, 
      telefone TEXT,
      endereco TEXT);
    """;
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          sql,
        );
      },
      version: 1,
    );
  }

//   Future<void> initialize() async {
//     final db = await _getDatabase();
// String sql = """CREATE TABLE IF NOT EXISTS clientes (
//       nome TEXT PRIMARY KEY,
//       CPF TEXT,
//       telefone TEXT,
//       endereco TEXT);
//     """;
//     db.execute(sql);
//   }

  Future<void> insertCliente(Cliente cliente) async {
    // Get a reference to the database.
    final db = await _getDatabase();

    await db.insert(
      'clientes',
      cliente.toJSON(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Cliente>> clientes() async {
    // Get a reference to the database.
    final db = await _getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('clientes');

    return List.generate(
      maps.length,
      (i) {
        return Cliente.fromJSON(maps[i]);
      },
    );
  }

  Future<Cliente> getClienteByName(String nome) async {
    final db = await _getDatabase();

    final List<Map<String, dynamic>> maps =
        await db.query('clientes', where: "nome = '$nome'", limit: 1);

    return Cliente.fromJSON(maps.first);
  }
}
