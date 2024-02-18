import 'package:flutter/material.dart';
import 'package:lumapp/models/cliente.dart';

class ClientItem extends StatefulWidget {
  final Cliente cliente;
  const ClientItem({super.key, required this.cliente});

  @override
  State<ClientItem> createState() => _ClientItemState();
}

class _ClientItemState extends State<ClientItem> {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}