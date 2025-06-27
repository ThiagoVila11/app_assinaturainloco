import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../models/cliente.dart';

class ClienteCard extends StatelessWidget {
  final Cliente cliente;
  final VoidCallback onFinalizado;

  const ClienteCard({
    super.key,
    required this.cliente,
    required this.onFinalizado,
  });

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
            Text("Contato: ${cliente.telefone} | ${cliente.email}"),
            Text("Local: ${cliente.condominio} - ${cliente.apto}"),
            Text("Score: ${cliente.score} | Processo Finalizado: ${cliente.processofinalizado ? "Sim" : "Não"}"),
            //Text("Assinar em: ${cliente.enderecoWebhook}"),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _botaoAcao("Consultar", Icons.search, Colors.blue, () {}),
                _botaoAcao("Editar", Icons.edit, Colors.orange, () {}),
                _botaoAcao("Gerar Contrato", Icons.description, Colors.purple, () {}),
                _botaoAcao(
                  "Assinar Contrato",
                  Icons.edit_document,
                  Colors.green,
                  () {
                      if (cliente.enderecoWebhook != null && cliente.enderecoWebhook!.isNotEmpty) {
                        _abrirLinkContrato(context, cliente.enderecoWebhook!);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Link de assinatura não disponível.")),
                        );
                      }
                    },
                ),
                _botaoAcao(
                  "Finalizar",
                  Icons.check_circle,
                  Colors.red,
                  () => _abrirDialogoFinalizar(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

  Future<void> _abrirLinkContrato(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o link')),
      );
    }
  }

  void _abrirDialogoFinalizar(BuildContext context) {
    bool processoFinalizado = true;
    TextEditingController obsController = TextEditingController();
    stt.SpeechToText speech = stt.SpeechToText();
    bool isListening = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> _listen() async {
              if (!isListening) {
                bool available = await speech.initialize(
                  onStatus: (status) => print("STATUS: $status"),
                  onError: (error) => print("ERRO: $error"),
                );
                if (available) {
                  setState(() => isListening = true);
                  speech.listen(
                    onResult: (result) {
                      setState(() {
                        obsController.text = result.recognizedWords;
                      });
                    },
                  );
                }
              } else {
                setState(() => isListening = false);
                speech.stop();
              }
            }

            return AlertDialog(
              title: const Text("Finalizar Processo"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    title: const Text("Processo Finalizado"),
                    value: processoFinalizado,
                    onChanged: (value) {
                      setState(() {
                        processoFinalizado = value ?? true;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: obsController,
                          decoration: const InputDecoration(
                            labelText: "Observação",
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                      ),
                      IconButton(
                        icon: Icon(isListening ? Icons.mic : Icons.mic_none),
                        tooltip: 'Falar',
                        onPressed: _listen,
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text("Cancelar"),
                  onPressed: () {
                    speech.stop();
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text("Salvar"),
                  onPressed: () async {
                    speech.stop();
                    await _enviarFinalizacao(context, processoFinalizado, obsController.text);
                    Navigator.of(context).pop();
                    onFinalizado();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _enviarFinalizacao(BuildContext context, bool finalizado, String observacao) async {
    final url = Uri.parse('http://192.168.3.37:8000/api/crudclientes/${cliente.id}/');
    print("Enviando finalização para $url");
    print("Dados enviados: processoFinalizado=$finalizado, observacao=$observacao");

    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "processofinalizado": finalizado,
        "observacoes": observacao,
      }),
    );

    print("Resposta do servidor: ${response.statusCode} - ${response.body}");

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
}
