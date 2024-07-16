import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Procuracao {
  String a;
  String b;
  DateTime vencimento;

  Procuracao({
    required this.a,
    required this.b,
    required this.vencimento,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'a': a,
      'b': b,
      'vencimento': vencimento.millisecondsSinceEpoch,
    };
  }

  factory Procuracao.fromMap(Map<String, dynamic> map) {
    return Procuracao(
      a: map['a'] as String,
      b: map['b'] as String,
      vencimento: DateTime.fromMillisecondsSinceEpoch(map['vencimento'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Procuracao.fromJson(String source) => Procuracao.fromMap(json.decode(source) as Map<String, dynamic>);
}
