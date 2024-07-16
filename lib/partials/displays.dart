import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumapp/models/debito.dart';
import 'package:validadores/Validador.dart';
import 'package:intl/intl.dart';


DateFormat format = DateFormat("dd/MM/yyyy");


Widget buildTipoSelector(TextEditingController controller) {
  return Container(
    child: DropdownMenu<TipoDebito>(
      leadingIcon: const Icon(Icons.numbers),
      label: const Text("Tipo Debito"),
      controller: controller,
      dropdownMenuEntries: TipoDebito.values.map((e) => DropdownMenuEntry(value: e, label: e.name)).toList(),
    ),
  );
}

Widget buildDisplay(String label, String content, IconData icon) {
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
        SizedBox(width: 5),
        Text(content),
      ],
    ),
  );
}

Widget textInput(String label, TextEditingController controller, double width, TextInputFormatter? formatter,
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

Widget editInput(String label, TextEditingController controller, double width, TextInputFormatter? formatter,
    {int maxLength = 20}) {
  return Container(
    width: width,
    child: TextFormField(
      style: const TextStyle(fontSize: 16),
      maxLength: maxLength,
      textCapitalization: TextCapitalization.characters,
      controller: controller,
      decoration: InputDecoration(
        labelStyle: const TextStyle(fontSize: 14),
        label: Text(label),
        hintText: label,
      ),
      validator: (value) => Validador().add(Validar.OBRIGATORIO).validar(value),
      inputFormatters: (formatter != null) ? [formatter] : [],
    ),
  );
}