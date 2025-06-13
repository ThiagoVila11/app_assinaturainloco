import 'package:flutter/material.dart';

class AgendaScreen extends StatelessWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text('Conteúdo da agenda aqui.'),
      ),
    );
  }
}