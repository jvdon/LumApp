import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lumapp/models/debito.dart';

class Car {
  late int id;
  late String cliente;
  late String placa;
  late Car_Colors color;
  late String marca;
  late String modelo;
  late int ano;
  late bool vendido;
  late double valor;

  late List<Debito> debitos;
  double totalDebitos = 0;

  Car({
    required this.cliente,
    required this.placa,
    required this.marca,
    required this.modelo,
    required this.ano,
    required this.vendido,
    required this.color,
    required this.debitos,
    required this.valor,
  }) {
    for (var e in debitos) {
      totalDebitos += e.valor;
    }
  }

  Car.fromJSON(Map json) {
    // json.forEach((key, value) { print(value.runtimeType);});

    id = json["id"];
    cliente = json["cliente"] as String;
    placa = json["placa"] as String;
    color = strToColor[json["color"] as String]!;
    marca = json["marca"] as String;
    modelo = json["modelo"] as String;
    ano = json["ano"];
    vendido = json["vendido"] == 1 ? true : false;

    debitos = (jsonDecode(json["debitos"]) as List)
        .map((e) => Debito.fromJSON(e))
        .toList();
    
    for (Debito debito in debitos) {
      totalDebitos += debito.valor;
    }
    
    debitos.map((e) => totalDebitos += e.valor);
    valor = json["valor"];
  }

  Map<String, dynamic> toMap() {
    return {
      "placa": placa,
      "color": color.name,
      "cliente":cliente,
      "marca": marca,
      "modelo": modelo,
      "ano": ano,
      "vendido": vendido ? 1 : 0,
      "valor": valor,
      "debitos": jsonEncode(debitos.map((e) => e.toMap()).toList()),
    };
  }
}

Map<String, Car_Colors> strToColor = {
  "PRETO": Car_Colors.PRETO,
  "CHUMBO": Car_Colors.CHUMBO,
  "PRATA": Car_Colors.PRATA,
  "BRANCO": Car_Colors.BRANCO,
  "VERMELHO": Car_Colors.VERMELHO,
  "AZUL": Car_Colors.AZUL
};

final Map<Car_Colors, Color> Cores = {
  Car_Colors.PRETO: Colors.black,
  Car_Colors.CHUMBO: Colors.grey[800]!,
  Car_Colors.PRATA: Colors.grey[700]!,
  Car_Colors.BRANCO: Colors.white,
  Car_Colors.AZUL: Colors.blueAccent[700]!,
  Car_Colors.VERMELHO: Colors.red[400]!
};

enum Car_Colors { PRETO, CHUMBO, PRATA, BRANCO, AZUL, VERMELHO }
