import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:lumapp/db/car_db.dart';
import 'package:lumapp/models/car.dart';
import 'package:lumapp/pages/cadastro_page.dart';

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
    return ListTile(
      leading: Icon(CupertinoIcons.car,
          color: Cores[widget.carro.color] ?? Colors.grey[700]),
      title: Text(
          "${widget.carro.marca} ${widget.carro.modelo} ${widget.carro.anoMod}/${widget.carro.anoFab}"),
      subtitle: Text(
          "Placa: ${widget.carro.placa} - Debitos:R\$ ${widget.carro.totalDebitos} - Valor:R\$ ${widget.carro.valor} - Lucro: ${widget.carro.valor - widget.carro.totalDebitos}"),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Container(
                height: 500,
                width: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("${widget.carro.marca} ${widget.carro.modelo}"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              _buildDisplay("Cliente", widget.carro.cliente,
                                  Icons.person),
                              SizedBox(
                                height: 10,
                              ),
                              _buildDisplay(
                                  "Mes",
                                  Meses.values[widget.carro.dataVenda-1].name,
                                  Icons.date_range),
                              SizedBox(
                                height: 10,
                              ),
                              _buildDisplay(
                                "Chassi",
                                widget.carro.chassi,
                                Icons.numbers,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              _buildDisplay(
                                "RENAVAM",
                                widget.carro.renavam,
                                Icons.numbers,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              _buildDisplay(
                                "Placa",
                                widget.carro.placa,
                                Icons.numbers,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              _buildDisplay(
                                "VALOR",
                                widget.carro.valor.toString(),
                                Icons.money_off,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: "Debitos",
                              labelStyle: const TextStyle(fontSize: 24),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Column(
                              children: widget.carro.debitos
                                  .map((e) => _buildDisplay(e.tipoDebito.name,
                                      e.valor.toString(), Icons.numbers))
                                  .toList(),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    _buildDisplay("Lucro", "R\$ ${widget.carro.valor-widget.carro.totalDebitos}", Icons.numbers)
                  ],
                ),
              ),
            );
          },
        );
      },
      trailing: (widget.carro.vendido == false)
          ? IconButton(
              icon: Icon(Icons.attach_money_sharp),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    MoneyMaskedTextController controller =
                        MoneyMaskedTextController(
                            decimalSeparator: ",",
                            thousandSeparator: ".",
                            leftSymbol: "R\$");

                    return Dialog(
                      child: Container(
                        width: 200,
                        child: Column(
                          children: [
                            Text(
                                "${widget.carro.marca} ${widget.carro.modelo}"),
                            textInput("Preço de Venda", controller, 200, null),
                            IconButton(
                              onPressed: () async {
                                await CarDB().venderCarro(
                                    widget.carro.id, controller.numberValue);
                                widget.notifyParent();
                                Navigator.of(context).pop();
                              },
                              icon: Text("VENDER"),
                            ),
                          ],
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
    );
  }
}

Widget _buildDisplay(String label, String content, IconData icon) {
  return InputDecorator(
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 24),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    child: Row(
      children: [
        Icon(icon),
        Text(content),
      ],
    ),
  );
}
