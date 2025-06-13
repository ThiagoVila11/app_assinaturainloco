import 'package:flutter/material.dart';
import '../models/cliente.dart';

class ClienteCard extends StatelessWidget {
  final Cliente cliente;

  const ClienteCard({super.key, required this.cliente});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cliente.nome, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text("CPF: ${cliente.cpf}"),
            Text("Email: ${cliente.email}"),
            Text("Score: ${cliente.score}"),
            if (cliente.condominio != null)
              Text("Condomínio: ${cliente.condominio}"),
            if (cliente.processoAssinaturaId != null)
              Text("Processo ID: ${cliente.processoAssinaturaId}"),
          ],
        ),
      ),
    );
  }
}
