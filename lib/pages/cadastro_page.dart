import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:lumapp/db/car_db.dart';
import 'package:lumapp/models/car.dart';
import 'package:lumapp/models/debito.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:validadores/Validador.dart';

class CadastroPage extends StatefulWidget {
  final TipoCadastro tipoCadastro;
  const CadastroPage({super.key, required this.tipoCadastro});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

// INfo
TextEditingController placa = TextEditingController();
TextEditingController revavam = TextEditingController();
TextEditingController chassi = TextEditingController();
TextEditingController tipo = TextEditingController();

// Carro
TextEditingController marca = TextEditingController();
TextEditingController modelo = TextEditingController();
TextEditingController anoMod = TextEditingController();
TextEditingController anoFab = TextEditingController();

TextEditingController color = TextEditingController();

MoneyMaskedTextController valor = MoneyMaskedTextController(
    decimalSeparator: ",", thousandSeparator: ".", leftSymbol: "R\$ ");

TextEditingController cliente = TextEditingController();

final _formKey = GlobalKey<FormState>();

List<Debito> debitos = [];
double debitoTotal = 0;

class _CadastroPageState extends State<CadastroPage> {
  @override
  void initState() {
    super.initState();
    placa = TextEditingController();
    revavam = TextEditingController();
    chassi = TextEditingController();
    tipo = TextEditingController();

    marca = TextEditingController();
    modelo = TextEditingController();
    anoMod = TextEditingController();
    anoFab = TextEditingController();

    color = TextEditingController();

    valor = MoneyMaskedTextController(
        decimalSeparator: ",", thousandSeparator: ".", leftSymbol: "R\$ ");

    cliente = TextEditingController();
    debitos = [];
    debitoTotal = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro: ${widget.tipoCadastro.name}"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              // Documentação(DOC)
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Documentação',
                  labelStyle: const TextStyle(fontSize: 24),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textInput("Cliente", cliente, 200, null),
                      textInput("RENAVAM", revavam, 200, null),
                      textInput("CHASSI", chassi, 200, null),
                      textInput(
                          "Placa Merco-Sul",
                          placa,
                          200,
                          MaskTextInputFormatter(
                              mask: '#######',
                              filter: {"#": RegExp(r'[A-Z0-9]')},
                              type: MaskAutoCompletionType.lazy)),
                      textInput(
                          "Placa Brasil",
                          placa,
                          200,
                          MaskTextInputFormatter(
                              mask: '###-####',
                              filter: {"#": RegExp(r'[A-Z0-9]')},
                              type: MaskAutoCompletionType.lazy)),
                      textInput("Valor", valor, 200, null)
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Carro
              SingleChildScrollView(
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Carro',
                    labelStyle: const TextStyle(fontSize: 24),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      textInput("Marca", marca, 100, null),
                      textInput("Modelo", modelo, 100, null),
                      textInput(
                        "Ano",
                        anoMod,
                        50,
                        MaskTextInputFormatter(
                            mask: '####',
                            filter: {"#": RegExp(r'[0-9]')},
                            type: MaskAutoCompletionType.lazy),
                      ),
                      textInput(
                        "Ano Modelo",
                        anoFab,
                        100,
                        MaskTextInputFormatter(
                            mask: '####',
                            filter: {"#": RegExp(r'[0-9]')},
                            type: MaskAutoCompletionType.lazy),
                      ),
                      DropdownMenu(
                          controller: tipo,
                          hintText: "Tipo Carro",
                          dropdownMenuEntries: TipoCarro.values
                              .map((e) => DropdownMenuEntry(
                                  value: e.name, label: e.name))
                              .toList()),
                      _buildColorSelector(color)
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Debitos
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Debitos',
                  labelStyle: const TextStyle(fontSize: 24),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 110,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 16,
                            child: ListView.builder(
                              itemCount: debitos.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                Debito debito = debitos[index];
                                return Column(children: [
                                  const Icon(Icons.monetization_on_sharp),
                                  Text(debito.tipoDebito.name),
                                  Text("R\$ ${debito.valor}"),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          debitoTotal -= debito.valor;
                                          debitos.remove(debito);
                                        });
                                      },
                                      icon: const Icon(Icons.remove_circle))
                                ]);
                              },
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    TextEditingController tipo =
                                        TextEditingController();

                                    TextEditingController info =
                                        TextEditingController();

                                    MoneyMaskedTextController valor =
                                        MoneyMaskedTextController(
                                            decimalSeparator: ",",
                                            thousandSeparator: ".",
                                            leftSymbol: "R\$ ");

                                    return Dialog(
                                      child: Container(
                                        width: 200,
                                        height: 260,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            _buildTipoSelector(tipo),
                                            textInput("Info", info, 150, null,
                                                maxLength: 200),
                                            textInput(
                                                "Valor", valor, 150, null),
                                            IconButton(
                                              onPressed: () {
                                                if (tipo.text.isNotEmpty &&
                                                    !valor.numberValue.isNaN) {
                                                  Debito debito = Debito(
                                                      tipoDebito: TipoDebito
                                                          .values
                                                          .byName(tipo.text),
                                                      info: info.text,
                                                      valor: valor.numberValue);
                                                  setState(() {
                                                    debitoTotal += debito.valor;
                                                    debitos.add(debito);
                                                    Navigator.of(context).pop();
                                                  });
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.add_card,
                                                size: 32,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.add_card),
                            ),
                          )
                        ],
                      ),
                    ),
                    Text("R\$ $debitoTotal"),
                  ],
                ),
              ),
              // const SizedBox(height: 10),
              const SizedBox(height: 10),
              InputDecorator(
                decoration: InputDecoration(
                  labelStyle: const TextStyle(fontSize: 24),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: IconButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool vendido =
                          (widget.tipoCadastro == TipoCadastro.COMPRA)
                              ? false
                              : true;
                      Car carro = Car(
                          cliente: cliente.text,
                          placa: placa.text,
                          marca: marca.text,
                          modelo: modelo.text,
                          chassi: chassi.text,
                          renavam: revavam.text,
                          tipo: TipoCarro.values.byName(tipo.text),
                          dataVenda: DateTime.now().month,
                          anoMod: int.tryParse(anoMod.text) ?? -1,
                          anoFab: int.tryParse(anoFab.text) ?? -1,
                          vendido: vendido,
                          color: Car_Colors.values.byName(color.text),
                          debitos: debitos,
                          valor: valor.numberValue);
                      try {
                        await CarDB().insertCarro(carro);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "${widget.tipoCadastro.name} realizada com sucesso")));
                        Navigator.of(context).pop();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Erro ao realizar ${widget.tipoCadastro.name}")));
                      }
                    }
                  },
                  icon: Text("Cadastrar ${widget.tipoCadastro.name}"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildTipoSelector(TextEditingController controller) {
  return Container(
    child: DropdownMenu<TipoDebito>(
      leadingIcon: Icon(Icons.numbers),
      label: const Text("Tipo Debito"),
      controller: controller,
      dropdownMenuEntries: TipoDebito.values
          .map((e) => DropdownMenuEntry(value: e, label: e.name))
          .toList(),
    ),
  );
}

Widget _buildColorSelector(TextEditingController controller) {
  return DropdownMenu(
      leadingIcon: Icon(
        Icons.color_lens_outlined,
        color: controller.text.isNotEmpty
            ? Cores[Car_Colors.values.byName(controller.text)]
            : Colors.white,
      ),
      label: const Text("Cor"),
      controller: controller,
      dropdownMenuEntries: Car_Colors.values
          .map((e) => DropdownMenuEntry(value: e, label: e.name))
          .toList());
}

Widget textInput(String label, TextEditingController controller, double width,
    TextInputFormatter? formatter,
    {int maxLength = 20}) {
  return Container(
    width: width,
    child: TextFormField(
      style: TextStyle(fontSize: 16),
      maxLength: maxLength,
      textCapitalization: TextCapitalization.characters,
      controller: controller,
      decoration: InputDecoration(
        labelStyle: TextStyle(fontSize: 14),
        label: Text(label),
        hintText: label,
      ),
      validator: (value) => Validador().add(Validar.OBRIGATORIO).validar(value),
      inputFormatters: (formatter != null) ? [formatter] : [],
    ),
  );
}

enum TipoCadastro { COMPRA, VENDA }
