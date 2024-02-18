import 'package:flutter/material.dart';
import 'package:lumapp/db/client_db.dart';
import 'package:lumapp/models/cliente.dart';
import 'package:lumapp/partials/client_item.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ClienteDB().clientes(),
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
              List<Cliente> clientes = snapshot.data!;

              return Scaffold(
                appBar: AppBar(
                  title: Text("Clientes cadastrados"),
                ),
                body: (clientes.isNotEmpty)
                    ? ListView.builder(
                        itemCount: clientes.length,
                        itemBuilder: (context, index) {
                          Cliente cliente = clientes[index];
                          return ListTile(
                            leading: Icon(Icons.person),
                            title: Text(cliente.nome),
                            subtitle: Text(cliente.telefone),
                          );
                        })
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning,
                              color: Colors.yellow[600],
                            ),
                            Text("Não há clientes cadastrados")
                          ],
                        ),
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
