import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lumapp/db/car_db.dart';
import 'package:lumapp/models/car.dart';
import 'package:lumapp/partials/client_item.dart';

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
          "${widget.carro.marca} ${widget.carro.modelo} ${widget.carro.ano}"),
      subtitle: Text(
          "Placa: ${widget.carro.placa} - Debitos:R\$ ${widget.carro.totalDebitos} - Valor:R\$ ${widget.carro.valor}"),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Container(
                height: 400,
                child: Column(
                  children: [
                    InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Placas',
                          labelStyle: const TextStyle(fontSize: 24),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Placeholder()),
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
                await CarDB().venderCarro(widget.carro.id);
                widget.notifyParent();
              },
            )
          : Icon(
              Icons.sell,
              color: Colors.green[600],
            ),
    );
  }
}
