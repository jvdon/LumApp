import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:lumapp/db/car_db.dart';
import 'package:lumapp/models/car.dart';
import 'package:lumapp/pages/cadastro_page.dart';
import 'package:lumapp/partials/car_item.dart';
import 'package:lumapp/partials/displays.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoughtPage extends StatefulWidget {
  const BoughtPage({super.key});

  @override
  State<BoughtPage> createState() => _BoughtPageState();
}

class _BoughtPageState extends State<BoughtPage> {
  Future vendidos = CarDB().vendidos();
  int month = DateTime.now().month - 1;

  refresh() {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CarDB().estoque(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red[600],
                    ),
                    const Text("Error fetching data")
                  ],
                ),
              );
            } else {
              List<Car> carros = snapshot.data!;
              double valorTotal = 0;
              double custoTotal = 0;

              for (var carro in carros) {
                valorTotal += carro.valor;
                custoTotal += carro.totalDebitos;
              }

              return Scaffold(
                appBar: AppBar(
                  title: const Text("Carros comprados"),
                  actions: [
                    IconButton(onPressed: refresh, icon: const Icon(Icons.refresh)),
                    DropdownMenu(
                      initialSelection: month,
                      dropdownMenuEntries:
                          Meses.values.map((e) => DropdownMenuEntry(label: e.name, value: e.index)).toList(),
                      onSelected: (value) {
                        if (value != null) {
                          setState(() {
                            month = value;
                            vendidos = CarDB().estoqueByMonth(value + 1);
                          });
                        }
                      },
                    ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  child: const Icon(Icons.add, size: 32),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CadastroPage(tipoCadastro: TipoCadastro.COMPRA),
                    ));
                  },
                ),
                body: Column(
                  children: [
                    Container(
                      height: 380,
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.blue[700]!, width: 3)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListTile(
                                leading: const Icon(CupertinoIcons.money_dollar),
                                title: const Text("Carros comprados:"),
                                subtitle: Text(carros.length.toString())),
                            ListTile(
                                leading: const Icon(CupertinoIcons.money_dollar),
                                title: const Text("Valor Total:"),
                                subtitle: Text("R\$ ${valorTotal}")),
                            ListTile(
                                leading: const Icon(CupertinoIcons.money_dollar),
                                title: const Text("Dispesa Total:"),
                                subtitle: Text("R\$ ${custoTotal}")),
                            ListTile(
                                leading: const Icon(CupertinoIcons.money_dollar),
                                title: const Text("Gasto Total:"),
                                subtitle: Text("R\$ ${valorTotal + custoTotal}")),
                            FutureBuilder(
                              future: SharedPreferences.getInstance(),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.done:
                                    if (snapshot.hasError) {
                                      return const ListTile(
                                        leading: Icon(Icons.error),
                                        title: Text("Error fetching"),
                                      );
                                    } else {
                                      SharedPreferences preferences = snapshot.requireData;
                                      MoneyMaskedTextController dinheiroCaixa = MoneyMaskedTextController(
                                          decimalSeparator: ",",
                                          thousandSeparator: ".",
                                          leftSymbol: "R\$",
                                          initialValue: double.parse(preferences.getString("caixa") ?? "-1"));
                                      return ListTile(
                                        leading: const Icon(CupertinoIcons.money_dollar),
                                        title: Row(
                                          children: [
                                            textInput("Dinheiro Em Caixa", dinheiroCaixa, 200, null),
                                            const SizedBox(width: 10),
                                            IconButton(
                                              onPressed: () async {
                                                bool ok = await preferences.setString(
                                                    "caixa", dinheiroCaixa.numberValue.toString());
                                                if (ok) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text("Salvo"),
                                                    ),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text("Error"),
                                                    ),
                                                  );
                                                }
                                              },
                                              icon: const Icon(Icons.save),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  case ConnectionState.waiting:
                                    return const CircularProgressIndicator();
                                  default:
                                    return const Text("Unable to fetch");
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: (carros.isNotEmpty)
                          ? ListView.builder(
                              itemCount: carros.length,
                              itemBuilder: (context, index) {
                                Car carro = carros[index];
                                return CarItem(
                                  carro: carro,
                                  notifyParent: refresh,
                                );
                              },
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.warning,
                                    color: Colors.yellow[600],
                                  ),
                                  const Text("Não há carros comprados")
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              );
            }
          default:
            return Center(
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red[600],
                  ),
                  const Text("Error fetching data")
                ],
              ),
            );
        }
      },
    );
  }
}
