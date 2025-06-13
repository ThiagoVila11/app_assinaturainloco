import 'package:flutter/material.dart';

class NotificacoesScreen extends StatelessWidget {
  const NotificacoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text('Lista de notificações aqui.'),
      ),
    );
  }
}
