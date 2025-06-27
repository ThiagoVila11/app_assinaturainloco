import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/api_service.dart';
import '../models/cliente.dart';

class NovoClienteScreen extends StatefulWidget {
  @override
  _NovoClienteScreenState createState() => _NovoClienteScreenState();
}

class _NovoClienteScreenState extends State<NovoClienteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();

  bool _isSalvando = false;

  Future<void> _salvarCliente() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSalvando = true;
      });

      Cliente novoCliente = Cliente(
        id: 0, // O backend pode gerar
        nome: _nomeController.text.trim(),
        cpf: _cpfController.text.trim(),
        score: '0',
        email: 'tts@bol.com',
        telefone: '11999999999',
        condominio: null, // Condominio pode ser null se não for obrigatório;
        apto: '',
        consultor: null, // Consultor pode ser null se não for obrigatório;
        processoAssinaturaId: null, // Processo de assinatura pode ser null se não for obrigatório;
        enderecoWebhook: null, // Endereço webhook pode ser null se não for obrigatório;
        processofinalizado: false,       
      );

      try {
        await ApiService.addCliente(novoCliente);
        Navigator.pop(context, true); // sinaliza sucesso
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar cliente: $e')),
        );
      } finally {
        setState(() {
          _isSalvando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo Cliente', style: GoogleFonts.poppins()),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cpfController,
                decoration: InputDecoration(labelText: 'CPF'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.length != 11 ? 'CPF inválido' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSalvando ? null : _salvarCliente,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: _isSalvando
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Salvar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
