class Cliente {
  late String nome;
  late String CPF;
  late String telefone;
  late String endereco;

  Cliente(
      {required this.nome,
      required this.CPF,
      required this.telefone,
      required this.endereco});

  Cliente.fromJSON(Map json) {
    nome = json["nome"];
    CPF = json["CPF"];
    telefone = json["telefone"];
    endereco = json["endereco"];
  }

  Map<String, dynamic> toJSON() {
    return {
      "nome": nome,
      "CPF": CPF,
      "telefone": telefone,
      "endereco": endereco
    };
  }
}
