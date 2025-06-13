import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
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
