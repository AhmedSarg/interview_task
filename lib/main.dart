import 'package:flutter/material.dart';
import 'package:interview/home_screen.dart';
import 'package:sqflite/sqflite.dart';

late Database db;

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // String path; getDatabasesPath();
    // db.query('InvoiceDetails', columns: ['lineNo', 'productName', '']);
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
