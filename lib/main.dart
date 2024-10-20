import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const SupplySyncApp());
}

class SupplySyncApp extends StatelessWidget {
  const SupplySyncApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SupplySync',
      theme: ThemeData(
        fontFamily: 'Jura', // Используем кастомный шрифт
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(), // Запускаем MainScreen
    );
  }
}
