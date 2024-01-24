import 'package:contratos_mpf/contratos/screens/contratos_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      brightness: MediaQuery.platformBrightnessOf(context),
      seedColor: Color(0xFF629784),
      primary: Color(0xFF629784),
      outline: Color(0xFF629784),
    );

    return MaterialApp(
      title: 'Contratos',
      theme: ThemeData(useMaterial3: false, colorScheme: colorScheme),
      home: ContratosScreen(),
    );
  }
}
