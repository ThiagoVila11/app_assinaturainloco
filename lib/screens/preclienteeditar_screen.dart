import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/precliente.dart';

class PreclienteEditarScreen extends StatefulWidget {
  final Precliente precliente;

  const PreclienteEditarScreen({super.key, required this.precliente});

  @override
  State<PreclienteEditarScreen> createState() => _PreclienteEditarScreenState();
}

class _PreclienteEditarScreenState extends State<PreclienteEditarScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _cpfController;
  late TextEditingController _emailController;
  late TextEditingController _apontamentosController;
  late TextEditingController _scoreController;

  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.precliente.preclienteNome);
    _cpfController = TextEditingController(text: widget.precliente.preclienteCpf);
    _emailController = TextEditingController(text: widget.precliente.precoclienteEmail);
    _apontamentosController = TextEditingController(text: widget.precliente.preclienteApontamentos);
    _scoreController = TextEditingController(text: widget.precliente.preclienteScore);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _emailController.dispose();
    _apontamentosController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  Future<void> _salvarAlteracoes() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    final url = Uri.parse('http://192.168.3.37:8000/api/preclientes/${widget.precliente.id}/');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "preclienteNome": _nomeController.text.trim(),
        "preclienteCpf": _cpfController.text.trim(),
        "precoclienteEmail": _emailController.text.trim(),
        "preclienteApontamentos": _apontamentosController.text.trim(),
        "preclienteScore": _scoreController.text.trim(),
      }),
    );

    setState(() => _salvando = false);

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pré-cliente atualizado com sucesso.")),
        );
        Navigator.of(context).pop(true); // Retorna true para recarregar lista
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar: ${response.body}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Pré-Cliente'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _campoTexto("Nome", _nomeController),
              _campoTexto("CPF", _cpfController),
              _campoTexto("Email", _emailController),
              _campoTexto("Apontamentos", _apontamentosController),
              _campoTexto("Score", _scoreController, tecladoNumerico: true),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: _salvando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Salvar"),
                onPressed: _salvando ? null : _salvarAlteracoes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoTexto(String label, TextEditingController controller, {bool tecladoNumerico = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: tecladoNumerico ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? "Campo obrigatório" : null,
      ),
    );
  }
}
