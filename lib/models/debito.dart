class Debito {
  late TipoDebito tipoDebito;
  late double valor;

  Debito({
    required this.tipoDebito,
    required this.valor,
  });

  Debito.fromJSON(Map json) {
    tipoDebito = TipoDebito.values.byName(
        json["tipoDebito"]); //  strToTipo[json["tipoDebito"] as String]!;
    valor = json["valor"];
  }

  Map<String, dynamic> toMap() {
    return {"tipoDebito": tipoDebito.name, "valor": valor};
  }
}

// Map<String, TipoDebito> strToTipo = {
//   "IPVA": TipoDebito.IPVA,
//   "MULTA": TipoDebito.MULTA,
//   "SEGURO": TipoDebito.SEGURO,
//   "PINTURA": TipoDebito.PINTURA,
//   "FUNILARIA": TipoDebito.FUNILARIA, MECANICA, LAVAGEM, MOTOR, ELETRICA, TAPECARIA, PNEU
// };

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
