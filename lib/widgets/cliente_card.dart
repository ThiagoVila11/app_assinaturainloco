import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/cliente.dart';

class ClienteCard extends StatelessWidget {
  final Cliente cliente;
  final VoidCallback onFinalizado; // para recarregar lista

  const ClienteCard({super.key, required this.cliente, required this.onFinalizado});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cliente.nome,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text("CPF: ${cliente.cpf}"),
            Text("Email: ${cliente.email}"),
            Text("Score: ${cliente.score}"),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _botaoAcao("Consultar", Icons.search, Colors.blue, () {}),
                _botaoAcao("Editar", Icons.edit, Colors.orange, () {}),
                _botaoAcao("Gerar Contrato", Icons.description, Colors.purple, () {}),
                _botaoAcao("Assinar Contrato", Icons.edit_document, Colors.green, () {}),
                _botaoAcao("Finalizar", Icons.check_circle, Colors.red, () {
                  _abrirDialogoFinalizar(context);
                }),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _abrirDialogoFinalizar(BuildContext context) {
    bool processoFinalizado = false;
    TextEditingController obsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Finalizar Processo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text("Processo Finalizado"),
              value: processoFinalizado,
              onChanged: (value) {
                processoFinalizado = value ?? true;
              },
            ),
            TextField(
              controller: obsController,
              decoration: const InputDecoration(
                labelText: "Observação",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text("Salvar"),
            onPressed: () async {
              await _enviarFinalizacao(context, processoFinalizado, obsController.text);
              Navigator.of(context).pop();
              onFinalizado(); // recarrega a lista
            },
          ),
        ],
      ),
    );
  }

  Future<void> _enviarFinalizacao(BuildContext context, bool finalizado, String observacao) async {
    final url = Uri.parse('https://inloco.vila11.com.br/api/crudclientes/${cliente.id}/');

    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "processofinalizado": finalizado,
        "observacoes": observacao,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Processo finalizado com sucesso.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao finalizar: ${response.body}")),
      );
    }
  }

  Widget _botaoAcao(String texto, IconData icone, Color cor, VoidCallback onPressed) {
    return ElevatedButton.icon(
      icon: Icon(icone, size: 18),
      label: Text(texto),
      style: ElevatedButton.styleFrom(
        backgroundColor: cor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: const TextStyle(fontSize: 14),
      ),
      onPressed: onPressed,
    );
  }
}
