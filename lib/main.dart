import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:clientes_app/screens/login_screen.dart';
import 'package:clientes_app/screens/home_screen.dart' as home_screen;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null); // ou o locale que você usa
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clientes App',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const LoginScreen(),
      routes: {
        '/home': (context) => const home_screen.HomeScreen(),
      },
    );
  }
}
