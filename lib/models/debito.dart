class Debito {
  late TipoDebito tipoDebito;
  late double valor;
  late String info;

  Debito({required this.tipoDebito, required this.valor, required this.info});

  Debito.fromJSON(Map json) {
    tipoDebito = TipoDebito.values.byName(
        json["tipoDebito"]); //  strToTipo[json["tipoDebito"] as String]!;
    valor = json["valor"];
    info = json["info"];
  }

  Map<String, dynamic> toMap() {
    return {
      "tipoDebito": tipoDebito.name,
      "valor": valor,
      "info": info,
    };
  }
}

enum TipoDebito {
  IPVA,
  MULTA,
  SEGURO,
  PINTURA,
  FUNILARIA,
  MECANICA,
  LAVAGEM,
  MOTOR,
  ELETRICA,
  TAPECARIA,
  PNEU,
}
