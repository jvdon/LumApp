import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lumapp/models/debito.dart';
import 'package:lumapp/models/procuracao.dart';

class Car {
  late int id;
  late String cliente;

  // Info
  late String placa;
  late String chassi;
  late String renavam;

  // Carro
  late Car_Colors color;
  late String marca;
  late String modelo;
  late int anoMod;
  late int anoFab;
  late TipoCarro tipo;

  // Venda
  late double valor;
  late DateTime dataVenda;
  late bool vendido;

  late List<Debito> debitos;
  double totalDebitos = 0;

  late List<Procuracao> procuracoes;

  Car({
    required this.cliente,
    required this.placa,
    required this.marca,
    required this.chassi,
    required this.renavam,
    required this.tipo,
    required this.dataVenda,
    required this.modelo,
    required this.anoMod,
    required this.anoFab,
    required this.vendido,
    required this.color,
    required this.debitos,
    required this.valor,
    required this.procuracoes,
  }) {
    totalDebitos = debitos.isEmpty ? 0 : debitos.map((e) => e.valor).reduce((a, b) => a + b);
  }

  Car.fromJSON(Map json) {
    // json.forEach((key, value) { print(value.runtimeType);});
    id = json["id"];
    // Info
    cliente = json["cliente"] as String;
    placa = json["placa"] as String;
    chassi = json["chassi"];
    renavam = json["renavam"];

    // Carro
    marca = json["marca"] as String;
    modelo = json["modelo"] as String;
    anoMod = json["anoMod"];
    anoFab = json["anoFab"];
    color = Car_Colors.values.byName(json["color"]);
    tipo = TipoCarro.values.byName(json["tipo"]);

    // Venda
    vendido = json["vendido"] == 1 ? true : false;
    valor = json["valor"];
    dataVenda = DateTime.fromMillisecondsSinceEpoch(json["dataVenda"]);
    debitos = (jsonDecode(json["debitos"]) as List).map((e) => Debito.fromJSON(e)).toList();

    totalDebitos = debitos.isEmpty ? 0 : debitos.map((e) => e.valor).reduce((a, b) => a + b);

    procuracoes = (jsonDecode(json["procuracoes"]) as List).map((e) => Procuracao.fromMap(e)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "placa": placa,
      "color": color.name,
      "cliente": cliente,
      "tipo": tipo.name,
      "renavam": renavam,
      "chassi": chassi,
      "marca": marca,
      "modelo": modelo,
      "anoMod": anoMod,
      "anoFab": anoFab,
      "vendido": vendido ? 1 : 0,
      "valor": valor,
      "dataVenda": dataVenda.millisecondsSinceEpoch,
      "debitos": jsonEncode(debitos.map((e) => e.toMap()).toList()),
      "procuracoes": jsonEncode(procuracoes.map((e) => e.toMap()).toList()),
    };
  }
}

final Map<Car_Colors, Color> Cores = {
  Car_Colors.PRETO: Colors.black,
  Car_Colors.CHUMBO: Colors.grey[800]!,
  Car_Colors.PRATA: Colors.grey[700]!,
  Car_Colors.BRANCO: Colors.white,
  Car_Colors.AZUL: Colors.blueAccent[700]!,
  Car_Colors.VERMELHO: Colors.red[400]!,
  Car_Colors.OUTRO: Colors.greenAccent.shade700
};

enum Car_Colors { PRETO, CHUMBO, PRATA, BRANCO, AZUL, VERMELHO, OUTRO }

enum TipoCarro {
  GASOLINA,
  DIESEL,
  FLEX,
  ALCOOL,
}

enum Meses { JANEIRO, FEVEREIRO, MARCO, ABRIL, MAIO, JUNHO, JULHO, AGOSTO, SETEMBRO, OUTUBRO, NOVEMBRO, DEZEMBRO }
