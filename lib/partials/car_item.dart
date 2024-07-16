import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:lumapp/db/car_db.dart';
import 'package:lumapp/models/car.dart';
import 'package:lumapp/models/debito.dart';
import 'package:lumapp/pages/edit_page.dart';
import 'package:lumapp/partials/textIcon.dart';
import 'displays.dart';

class CarItem extends StatefulWidget {
  final Car carro;
  final Function() notifyParent;
  const CarItem({super.key, required this.carro, required this.notifyParent});
  
  @override
  State<CarItem> createState() => _CarItemState();
}

class _CarItemState extends State<CarItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(CupertinoIcons.car, color: Cores[widget.carro.color] ?? Colors.grey[700]),
        title: Text("${widget.carro.marca} ${widget.carro.modelo} ${widget.carro.anoMod}/${widget.carro.anoFab}"),
        subtitle: Row(
          children: [
            Text("Placa: ${widget.carro.placa}"),
            SizedBox(width: 10),
            Text("Débitos: R\$ ${widget.carro.totalDebitos}"),
            SizedBox(width: 10),
            Text("Valor: R\$ ${widget.carro.valor}"),
            SizedBox(width: 10),
            Text("Lucro: ${widget.carro.valor - widget.carro.totalDebitos}"),
            SizedBox(width: 10),
            TextIcon(text: format.format(widget.carro.dataVenda), icon: Icons.date_range, width: 200),
          ],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Container(
                  height: 560,
                  width: 500,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                buildDisplay("Carro", "${widget.carro.marca} ${widget.carro.modelo}", Icons.car_crash),
                                const SizedBox(height: 10),
                                buildDisplay("Cliente", widget.carro.cliente, Icons.person),
                                const SizedBox(height: 10),
                                buildDisplay("Data ${widget.carro.vendido ? "Venda" : "Compra"} ",
                                    format.format(widget.carro.dataVenda), Icons.date_range),
                                const SizedBox(height: 10),
                                buildDisplay("Chassi", widget.carro.chassi, Icons.numbers),
                                const SizedBox(height: 10),
                                buildDisplay("RENAVAM", widget.carro.renavam, Icons.numbers),
                                const SizedBox(height: 10),
                                buildDisplay("Placa", widget.carro.placa, Icons.numbers),
                                const SizedBox(height: 10),
                                buildDisplay("VALOR", widget.carro.valor.toString(), Icons.money_off),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: "Debitos",
                                labelStyle: const TextStyle(fontSize: 24),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white, width: 2),
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              child: Container(
                                height: 450,
                                child: ListView.builder(
                                  itemCount: widget.carro.debitos.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    Debito debito = widget.carro.debitos[index];

                                    return ListTile(
                                      title: Text(debito.tipoDebito.name),
                                      subtitle: Text(debito.info),
                                      trailing: Text("R\$ ${debito.valor.toString()}"),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      buildDisplay("Lucro", "R\$ ${widget.carro.valor - widget.carro.totalDebitos}", Icons.numbers)
                    ],
                  ),
                ),
              );
            },
          );
        },
        trailing: Container(
          width: 220,
          child: Row(
            children: [
              //! Deletar
              IconButton(
                icon: const Icon(CupertinoIcons.delete),
                tooltip: "Deletar Carro",
                onPressed: () async {
                  CarDB db = CarDB();
                  db.deleteCarro(widget.carro);
                  widget.notifyParent();

                  setState(() {});
                },
              ),
              //! Editar Carro Button
              IconButton(
                icon: const Icon(CupertinoIcons.car_detailed),
                tooltip: "Editar Carro",
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditPage(carro: widget.carro),
                    ),
                  );
                },
              ),
              //! Sell Button
              IconButton(
                icon: const Icon(CupertinoIcons.pencil),
                tooltip: "Editar Débitos",
                onPressed: () async {
                  CarDB db = CarDB();

                  List<Debito> debitos = widget.carro.debitos;
                  double debitoTotal = 0;

                  TextEditingController tipo = TextEditingController();

                  TextEditingController info = TextEditingController();

                  TextEditingController amount = TextEditingController(text: "1");

                  MoneyMaskedTextController valor =
                      MoneyMaskedTextController(decimalSeparator: ",", thousandSeparator: ".", leftSymbol: "R\$ ");

                  debitos.forEach(
                    (element) => debitoTotal += element.valor,
                  );

                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Dialog(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: InputDecorator(
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
                                    Expanded(
                                      flex: 4,
                                      child: ListView.builder(
                                        itemCount: debitos.length,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          Debito debito = debitos[index];

                                          return ListTile(
                                            title: Text(debito.tipoDebito.name),
                                            subtitle: Text(debito.info),
                                            trailing: Text("R\$ ${debito.valor.toString()}"),
                                            leading: IconButton(
                                              icon: const Icon(CupertinoIcons.minus_circle),
                                              onPressed: () {
                                                setState(
                                                  () {
                                                    debitoTotal -= debito.valor;
                                                    debitos.remove(debito);

                                                    widget.carro.debitos = debitos;
                                                    db.update(widget.carro, widget.carro.id);
                                                  },
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Column(
                                        children: [
                                          buildTipoSelector(tipo),
                                          Container(
                                            width: 330,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                textInput("Info", info, 150, null),
                                                const SizedBox(width: 10),
                                                textInput("Valor", valor, 150, null),
                                              ],
                                            ),
                                          ),
                                          textInput("Quantidade", amount, 200, null),
                                          IconButton(
                                            onPressed: () {
                                              Debito debito = Debito(
                                                  tipoDebito: TipoDebito.values.byName(tipo.text),
                                                  info: info.text,
                                                  valor: valor.numberValue);

                                              setState(
                                                () {
                                                  int amountInt = int.tryParse(amount.text) ?? 1;

                                                  for (var i = 0; i < amountInt; i++) {
                                                    debitoTotal += debito.valor;
                                                    debitos.add(debito);
                                                  }
                                                  widget.carro.debitos = debitos;
                                                  db.update(widget.carro, widget.carro.id);
                                                },
                                              );
                                            },
                                            icon: const Icon(Icons.add_card),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              (widget.carro.vendido == false)
                  ? IconButton(
                      tooltip: "Vender Carro",
                      icon: const Icon(Icons.attach_money_sharp),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            MoneyMaskedTextController controller = MoneyMaskedTextController(
                                decimalSeparator: ",", thousandSeparator: ".", leftSymbol: "R\$");
                            DateTime dataVenda = DateTime.now();
                            return StatefulBuilder(
                              builder: (context, setState) => Dialog(
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  child: Column(
                                    children: [
                                      Text("${widget.carro.marca} ${widget.carro.modelo}"),
                                      textInput("Preço de Venda", controller, 200, null),
                                      GestureDetector(
                                        child: buildDisplay("Data Venda", format.format(dataVenda), Icons.date_range),
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            firstDate: DateTime.now().subtract(Duration(days: 90)),
                                            currentDate: dataVenda,
                                            lastDate: DateTime.now().add(
                                              Duration(days: 90),
                                            ),
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
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          // widget.carro.dataVenda =
                                          await CarDB().venderCarro(widget.carro.id, controller.numberValue, dataVenda);
                                          widget.notifyParent();
                                          Navigator.of(context).pop();
                                        },
                                        icon: const Text("VENDER"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    )
                  : Icon(
                      Icons.sell,
                      color: Colors.green[600],
                    ),
              //! Warnings
              IconButton(
                onPressed: () async {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        width: 700,
                        height: 400,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              if (DateTime.now().isAfter(widget.carro.dataVenda.add(Duration(days: 90))))
                                buildDisplay(
                                    "Garantia",
                                    "Expirada Venceu Dia: ${format.format(widget.carro.dataVenda.add(Duration(days: 90)))}",
                                    Icons.date_range_outlined)
                              else
                                buildDisplay(
                                    "Garantia",
                                    "Vence Dia: ${format.format(widget.carro.dataVenda.add(Duration(days: 90)))}",
                                    Icons.date_range_outlined),
                              if (widget.carro.dataVenda.isAfter(DateTime.now().add(Duration(days: 90))))
                                buildDisplay("Procuração", "content", Icons.date_range_outlined),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: Icon(Icons.warning, color: Colors.yellow, size: 32),
                tooltip: "Avisos",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
