import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lumapp/db/car_db.dart';
import 'package:lumapp/models/car.dart';
import 'package:lumapp/pages/cadastro_page.dart';
import 'package:lumapp/partials/car_item.dart';

class BoughtPage extends StatefulWidget {
  const BoughtPage({super.key});

  @override
  State<BoughtPage> createState() => _BoughtPageState();
}

class _BoughtPageState extends State<BoughtPage> {
  Future vendidos = CarDB().vendidos();
  int month = DateTime.now().month-1;


  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CarDB().estoque(),
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
                  title: Text("Carros comprados"),
                  actions: [
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
                            vendidos = CarDB().estoqueByMonth(value + 1);
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
                          CadastroPage(tipoCadastro: TipoCadastro.COMPRA),
                    ));
                  },
                ),
                body: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.blue[700]!, width: 3)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListTile(
                                title: Text("Carros comprados:"),
                                subtitle: Text(carros.length.toString())),
                            ListTile(
                                title: Text("Valor Total:"),
                                subtitle: Text("R\$ ${valorTotal}")),
                            ListTile(
                                title: Text("Dispesa Total:"),
                                subtitle: Text("R\$ ${custoTotal}")),
                            ListTile(
                                title: Text("Gasto Total:"),
                                subtitle: Text("R\$ ${valorTotal+custoTotal}")),
                            
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
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
                                  Text("Não há carros comprados")
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
