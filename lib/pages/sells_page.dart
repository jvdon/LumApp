import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lumapp/db/car_db.dart';
import 'package:lumapp/models/car.dart';
import 'package:lumapp/pages/cadastro_page.dart';
import 'package:lumapp/partials/car_item.dart';
import 'package:lumapp/partials/displays.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:open_filex/open_filex.dart';

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
                    IconButton(
                        onPressed: () async {
                          final pdf = pw.Document();
                          pdf.addPage(
                            pw.Page(
                              pageFormat: PdfPageFormat.a4,
                              build: (pw.Context context) {
                                if (carros.isNotEmpty) {
                                  print(context.page.size.toDouble());
                                  return pw.Column(
                                    mainAxisAlignment: pw.MainAxisAlignment.start,
                                    children: [
                                      pw.Container(
                                        height: 100,
                                        width: double.infinity,
                                        child: pw.Column(
                                          mainAxisAlignment: pw.MainAxisAlignment.start,
                                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Text("Carros: ${carros.length}"),
                                            pw.SizedBox(width: 10),
                                            pw.Text(
                                                "Valor Total: R\$ ${carros.isEmpty ? 0 : carros.map((e) => e.valor).reduce((value, element) => value + element)}"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return pw.Center(child: pw.Column(children: [pw.Text("Nenhum Carro Cadastrado")]));
                                }
                              },
                            ),
                          );

                          for (var i = 0; i < carros.length; i += 3) {
                            var carroSubset = [carros.elementAtOrNull(i), carros.elementAtOrNull(i + 1),carros.elementAtOrNull(i + 2) ];
                            print(i);
                            pdf.addPage(
                              pw.Page(
                                pageFormat: PdfPageFormat.a4,
                                build: (pw.Context context) {
                                  if (carros.isNotEmpty) {
                                    print(context.page.size.toDouble());
                                    return pw.ListView.builder(
                                      itemCount: carroSubset.length,
                                      itemBuilder: (context, index) {
                                        Car? carro = carroSubset[index];
                                        if (carro != null) {
                                          return pw.Column(
                                            mainAxisAlignment: pw.MainAxisAlignment.start,
                                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.Row(children: [
                                                pw.Text("#${carro.id.toString()}"),
                                                pw.SizedBox(width: 5),
                                                pw.Text("${carro.marca} ${carro.modelo}"),
                                                pw.SizedBox(width: 5),
                                                pw.Text(carro.cliente)
                                              ]),
                                              pw.SizedBox(height: 20),
                                              pw.Column(
                                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                                children: [
                                                  pw.Text("Placa: ${carro.placa}"),
                                                  pw.SizedBox(height: 5),
                                                  pw.Text("CHASSI: ${carro.chassi}"),
                                                  pw.SizedBox(height: 5),
                                                  pw.Text("RENAVAM: ${carro.renavam}"),
                                                  pw.SizedBox(height: 5),
                                                  pw.Text("Cor: ${carro.color.name}"),
                                                  pw.SizedBox(height: 5),
                                                  pw.Text("Tipo Motor: ${carro.tipo.name} "),
                                                  pw.SizedBox(height: 5),
                                                  pw.Text("Ano Modelo: ${carro.anoMod}"),
                                                  pw.SizedBox(height: 5),
                                                  pw.Text("Ano: ${carro.anoFab}"),
                                                  pw.SizedBox(height: 5),
                                                  pw.Text("Valor: R\$ ${carro.valor}"),
                                                  pw.SizedBox(height: 5),
                                                  pw.Text("Debitos: R\$ ${carro.totalDebitos}"),
                                                  pw.SizedBox(height: 5),
                                                ],
                                              ),
                                              pw.SizedBox(height: 20),
                                            ],
                                          );
                                        } else {
                                          return pw.Container();
                                        }
                                      },
                                    );
                                  } else {
                                    return pw.Center(child: pw.Column(children: [pw.Text("Nenhum Carro Cadastrado")]));
                                  }
                                },
                              ),
                            );
                          }

                          final documentsPath = await getApplicationDocumentsDirectory();

                          final filePath =
                              join(documentsPath.path, "Venda_${DateTime.now().month}_${DateTime.now().year}.pdf");
                          final file = File(filePath);
                          await file.writeAsBytes(await pdf.save());
                          OpenFilex.open(filePath);

                          print(filePath);
                        },
                        icon: const Icon(Icons.print_rounded)),
                    IconButton(onPressed: refresh, icon: Icon(Icons.refresh)),
                    DropdownMenu(
                      initialSelection: month,
                      dropdownMenuEntries:
                          Meses.values.map((e) => DropdownMenuEntry(label: e.name, value: e.index)).toList(),
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
                      builder: (context) => CadastroPage(tipoCadastro: TipoCadastro.VENDA),
                    ));
                  },
                ),
                body: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.blue[700]!, width: 3)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListTile(title: Text("Carros vendidos:"), subtitle: Text(carros.length.toString())),
                            ListTile(title: Text("Valor Total:"), subtitle: Text("R\$ ${valorTotal}")),
                            ListTile(title: Text("Dispesa Total:"), subtitle: Text("R\$ ${custoTotal}")),
                            ListTile(title: Text("Lucro:"), subtitle: Text("R\$ ${valorTotal - custoTotal}")),
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
