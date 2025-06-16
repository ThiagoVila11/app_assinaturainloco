import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null); // <- Isso é o que resolve
  runApp(const ClientesApp());
}

class ClientesApp extends StatelessWidget {
  const ClientesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assinatura in loco',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const LoginScreen(), // 👉 Começa pela tela de login
      debugShowCheckedModeBanner: false,
    );
  }
}
