import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:lumapp/db/car_db.dart';
import 'package:lumapp/models/car.dart';
import 'package:lumapp/models/debito.dart';
import 'package:lumapp/partials/textIcon.dart';
import '../partials/displays.dart';

class EditPage extends StatefulWidget {
  Car carro;
  EditPage({super.key, required this.carro});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
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

  MoneyMaskedTextController valor =
      MoneyMaskedTextController(decimalSeparator: ",", thousandSeparator: ".", leftSymbol: "R\$ ");

  TextEditingController cliente = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DateTime dataVenda = DateTime.now();

  @override
  void initState() {
    placa = TextEditingController(text: widget.carro.placa);
    revavam = TextEditingController(text: widget.carro.renavam);
    chassi = TextEditingController(text: widget.carro.chassi);
    tipo = TextEditingController(text: widget.carro.tipo.name);
    marca = TextEditingController(text: widget.carro.marca);
    modelo = TextEditingController(text: widget.carro.modelo);
    anoMod = TextEditingController(text: widget.carro.anoMod.toString());
    anoFab = TextEditingController(text: widget.carro.anoFab.toString());
    color = TextEditingController(text: widget.carro.color.name);
    valor = MoneyMaskedTextController(
      decimalSeparator: ",",
      thousandSeparator: ".",
      leftSymbol: "R\$ ",
      initialValue: widget.carro.valor,
    );
    cliente = TextEditingController(text: widget.carro.cliente);
    dataVenda = widget.carro.dataVenda;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Carro"),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      editInput("CLIENTE", cliente, 200, null),
                      const SizedBox(height: 10),
                      editInput("CHASSI", chassi, 200, null),
                      const SizedBox(height: 10),
                      editInput("RENAVAM", revavam, 200, null),
                      const SizedBox(height: 10),
                      editInput("PLACA", placa, 200, null),
                      const SizedBox(height: 10),
                      editInput("VALOR", valor, 200, null),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      editInput("MARCA", marca, 200, null),
                      const SizedBox(height: 10),
                      editInput("MODELO", modelo, 200, null),
                      const SizedBox(height: 10),
                      editInput("ANO MODELO", anoMod, 200, null),
                      const SizedBox(height: 10),
                      Container(
                        width: 200,
                        height: 50,
                        child: GestureDetector(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              firstDate: DateTime.now().subtract(Duration(days: 270)),
                              currentDate: dataVenda,
                              lastDate: DateTime.now().add(Duration(days: 270)),
                            ).then(
                              (value) {
                                if (value != null) {
                                  setState(() {
                                    dataVenda = value;
                                  });
                                }
                              },
                            );
                          },
                          child: TextIcon(text: format.format(dataVenda), icon: Icons.date_range, width: 200),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownMenu(
                        width: 200,
                        controller: tipo,
                        label: const Text(
                          "Tipo Motor",
                        ),
                        hintText: "Tipo Carro",
                        dropdownMenuEntries:
                            TipoCarro.values.map((e) => DropdownMenuEntry(value: e.name, label: e.name)).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                int id = widget.carro.id;
                Car carro = Car(
                  cliente: cliente.text,
                  placa: placa.text,
                  marca: marca.text,
                  modelo: modelo.text,
                  chassi: chassi.text,
                  renavam: revavam.text,
                  tipo: TipoCarro.values.byName(tipo.text),
                  dataVenda: dataVenda,
                  anoMod: int.tryParse(anoMod.text) ?? -1,
                  anoFab: int.tryParse(anoFab.text) ?? -1,
                  vendido: widget.carro.vendido,
                  color: Car_Colors.values.byName(color.text),
                  debitos: widget.carro.debitos,
                  valor: valor.numberValue,
                  procuracoes: widget.carro.procuracoes,
                );

                widget.carro = carro;
                try {
                  await CarDB().update(widget.carro, id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Carro atualizado com sucesso"),
                    ),
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Erro ao atualizar carro ${e}"),
                    ),
                  );
                }
              }

              // db.update(carro);
            },
            icon: const Icon(Icons.save),
            tooltip: "Salvar",
          )
        ],
      ),
    );
  }
}

Widget _buildTipoSelector(TextEditingController controller) {
  return Container(
    child: DropdownMenu<TipoDebito>(
      leadingIcon: const Icon(Icons.numbers),
      label: const Text("Tipo Debito"),
      controller: controller,
      dropdownMenuEntries: TipoDebito.values.map((e) => DropdownMenuEntry(value: e, label: e.name)).toList(),
    ),
  );
}
