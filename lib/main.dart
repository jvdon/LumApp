import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lumapp/pages/bought_page.dart';
import 'package:lumapp/pages/sells_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
  }
  // Change the default factory. On iOS/Android, if not using `sqlite_flutter_lib` you can forget
  // this step, it will use the sqlite version available on the system.
  databaseFactory = databaseFactoryFfi;

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currPage = 0;
  List<Widget> pages = [SellsPage(), BoughtPage()];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      title: "LUMAPP",
      home: Scaffold(
        body: pages[currPage],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currPage,
          selectedItemColor: Colors.green,
          onTap: (value) {
            setState(() {
              currPage = value;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.outbound), label: "Vendidos"),
            BottomNavigationBarItem(icon: Icon(Icons.monetization_on_outlined), label: "Estoque"),
          ],
        ),
      ),
    );
  }
}
