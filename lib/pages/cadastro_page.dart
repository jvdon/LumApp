import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:lumapp/db/car_db.dart';
import 'package:lumapp/db/client_db.dart';
import 'package:lumapp/models/car.dart';
import 'package:lumapp/models/cliente.dart';
import 'package:lumapp/models/debito.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:validadores/Validador.dart';

class CadastroPage extends StatefulWidget {
  final TipoCadastro tipoCadastro;
  const CadastroPage({super.key, required this.tipoCadastro});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

TextEditingController placa = TextEditingController();

// Carro
TextEditingController marca = TextEditingController();
TextEditingController modelo = TextEditingController();
TextEditingController ano = TextEditingController();
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

    marca = TextEditingController();
    modelo = TextEditingController();
    ano = TextEditingController();
    color = TextEditingController();

    valor = MoneyMaskedTextController(
        decimalSeparator: ",", thousandSeparator: ".", leftSymbol: "R\$ ");

    TextEditingController cliente = TextEditingController();
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
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            // Cliente
            DropdownSearch<String>(
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                showSelectedItems: true,
                // disabledItemFn: (String s) => s.startsWith('I'),
              ),
              asyncItems: (text) async =>
                  (await ClienteDB().clientes()).map((e) => e.nome).toList(),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Cliente",
                  hintText: "Cliente",
                ),
              ),
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    cliente.text = value;
                  }
                });
              },
            ),
            const SizedBox(
              height: 5,
            ),
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Container(
                          height: 300,
                          child: _buildClientCadastro(context),
                        ),
                      );
                    },
                  );
                },
                icon: const Text("Cadastrar cliente")),
            const SizedBox(
              height: 10,
            ),
            // Placas(DOC)
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Placas',
                labelStyle: const TextStyle(fontSize: 24),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  textInput("Placa Merco-Sul", placa, 200, MaskTextInputFormatter(
                  mask: '######',
                  filter: {"#": RegExp(r'[A-Z0-9]')},
                  type: MaskAutoCompletionType.lazy)),
                  textInput("Placa Brasil", placa, 200, MaskTextInputFormatter(
                  mask: '###-####',
                  filter: {"#": RegExp(r'[A-Z0-9]')},
                  type: MaskAutoCompletionType.lazy)),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // Carro
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Carro',
                labelStyle: const TextStyle(fontSize: 24),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2),
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
                    ano,
                    50,
                    MaskTextInputFormatter(
                        mask: '####',
                        filter: {"#": RegExp(r'[0-9]')},
                        type: MaskAutoCompletionType.lazy),
                  ),
                  _buildColorSelector(color)
                ],
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

                                  MoneyMaskedTextController valor =
                                      MoneyMaskedTextController(
                                          decimalSeparator: ",",
                                          thousandSeparator: ".",
                                          leftSymbol: "R\$ ");

                                  return Dialog(
                                    child: Container(
                                      width: 200,
                                      height: 200,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          _buildTipoSelector(tipo),
                                          textInput("Valor", valor, 150, null),
                                          IconButton(
                                            onPressed: () {
                                              if (tipo.text.isNotEmpty &&
                                                  !valor.numberValue.isNaN) {
                                                Debito debito = Debito(
                                                    tipoDebito: TipoDebito
                                                        .values
                                                        .byName(tipo.text),
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
            const SizedBox(height: 10),
            // Valor
            InputDecorator(
                decoration: InputDecoration(
                  labelStyle: const TextStyle(fontSize: 24),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: textInput("Valor", valor, 200, null)),
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
                    bool vendido = (widget.tipoCadastro == TipoCadastro.COMPRA)
                        ? false
                        : true;
                    Car carro = Car(
                        cliente: cliente.text,
                        placa: placa.text,
                        marca: marca.text,
                        modelo: modelo.text,
                        ano: int.tryParse(ano.text) ?? -1,
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
    );
  }
}

Widget _buildTipoSelector(TextEditingController controller) {
  return Container(
    child: DropdownMenu<TipoDebito>(
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
      label: const Text("Cor"),
      controller: controller,
      dropdownMenuEntries: Car_Colors.values
          .map((e) => DropdownMenuEntry(value: e, label: e.name))
          .toList());
}

Widget _buildClientCadastro(context) {
  TextEditingController nomeCliente = TextEditingController();
  TextEditingController telefone = TextEditingController();

  TextEditingController CPF = TextEditingController();
  TextEditingController endereco = TextEditingController();

  final key = GlobalKey();
  return Form(
    key: key,
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: 'Cliente',
        labelStyle: const TextStyle(fontSize: 24),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Column(
        children: [
          TextFormField(
            controller: nomeCliente,
            decoration: const InputDecoration(label: Text("Nome: ")),
            validator: (value) => Validador()
                .add(Validar.OBRIGATORIO, msg: "Campo Obrigatorio")
                .valido(value),
          ),
          TextFormField(
            controller: telefone,
            decoration: const InputDecoration(label: Text("Telefone: ")),
            validator: (value) => Validador()
                .add(Validar.OBRIGATORIO, msg: "Campo Obrigatorio")
                .valido(value),
            inputFormatters: [
              MaskTextInputFormatter(
                  mask: '+55 (##) ####-#####',
                  filter: {"#": RegExp(r'[0-9]')},
                  type: MaskAutoCompletionType.lazy)
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: CPF,
                  decoration: const InputDecoration(label: Text("CPF: ")),
                  validator: (value) => Validador()
                      .add(Validar.OBRIGATORIO, msg: "Campo Obrigatorio")
                      .add(Validar.CPF, msg: "CPF Invalido")
                      .valido(value),
                  inputFormatters: [
                    MaskTextInputFormatter(
                        mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')})
                  ],
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: CPF,
                  decoration: const InputDecoration(label: Text("CPF: ")),
                  validator: (value) => Validador()
                      .add(Validar.OBRIGATORIO, msg: "Campo Obrigatorio")
                      .add(Validar.CNPJ, msg: "CPF Invalido")
                      .valido(value),
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: "##.###.###/####-##",
                      filter: {"#": RegExp(r'[0-9]')},
                    )
                  ],
                ),
              ),
            ],
          ),
          TextFormField(
            controller: endereco,
            decoration: const InputDecoration(
              label: Text("Endereço: "),
            ),
          ),
          IconButton(
            onPressed: () async {
              try {
                Cliente cliente = Cliente(
                    nome: nomeCliente.text,
                    CPF: CPF.text,
                    telefone: telefone.text,
                    endereco: endereco.text);
                await ClienteDB().insertCliente(cliente);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Cliente cadastrado com sucesso"),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Erro ao cadastrar cliente"),
                  ),
                );
              }

              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.person_add,
              size: 24,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget textInput(String label, TextEditingController controller, double width,
    TextInputFormatter? formatter) {
  return Container(
    width: width,
    child: TextFormField(
      maxLength: 20,
      textCapitalization: TextCapitalization.characters,
      controller: controller,
      decoration: InputDecoration(
        label: Text(label),
        hintText: label,
      ),
      validator: (value) => Validador().add(Validar.OBRIGATORIO).validar(value),
      inputFormatters: (formatter != null) ? [formatter] : [],
    ),
  );
}

enum TipoCadastro { COMPRA, VENDA }
