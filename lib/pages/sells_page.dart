import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lumapp/db/car_db.dart';
import 'package:lumapp/models/car.dart';
import 'package:lumapp/pages/cadastro_page.dart';
import 'package:lumapp/partials/car_item.dart';

class SellsPage extends StatefulWidget {
  const SellsPage({super.key});

  @override
  State<SellsPage> createState() => _SellsPageState();
}

class _SellsPageState extends State<SellsPage> {
  Future vendidos = CarDB().vendidos();
  int month = DateTime.now().month - 1;

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CarDB().vendidos(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red[600],
                    ),
                    Text("Error fetching data")
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
                  title: Text("Carros vendidos"),
                  actions: [
                    IconButton(onPressed: refresh, icon: Icon(Icons.refresh)),
                    DropdownMenu(
                      initialSelection: month,
                      dropdownMenuEntries: Meses.values
                          .map((e) =>
                              DropdownMenuEntry(label: e.name, value: e.index))
                          .toList(),
                      onSelected: (value) {
                        if (value != null) {
                          setState(() {
                            month = value;
                            vendidos = CarDB().vendidosByMonth(value + 1);
                          });
                        }
                        print(value);
                      },
                    ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add, size: 32),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          CadastroPage(tipoCadastro: TipoCadastro.VENDA),
                    ));
                  },
                ),
                body: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.blue[700]!, width: 3)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListTile(
                                title: Text("Carros vendidos:"),
                                subtitle: Text(carros.length.toString())),
                            ListTile(
                                title: Text("Valor Total:"),
                                subtitle: Text("R\$ ${valorTotal}")),
                            ListTile(
                                title: Text("Dispesa Total:"),
                                subtitle: Text("R\$ ${custoTotal}")),
                            ListTile(
                                title: Text("Lucro:"),
                                subtitle:
                                    Text("R\$ ${valorTotal - custoTotal}")),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
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
                                  Text("Não há carros vendidos")
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
                  Text("Error fetching data")
                ],
              ),
            );
        }
      },
    );
  }
}
