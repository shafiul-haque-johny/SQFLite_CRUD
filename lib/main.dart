import 'package:flutter/material.dart';
import 'package:sqflite_crud/sql_helper.dart';
import 'package:sqflite_crud/sql_home_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {
// Initialize FFI
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(MyApp());
}

//void main() {
//  runApp(const MyApp());
//}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SQLITE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
