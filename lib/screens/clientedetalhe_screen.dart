import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/cliente.dart';

class DetalhesClienteScreen extends StatefulWidget {
  final int clienteId;

  const DetalhesClienteScreen({Key? key, required this.clienteId}) : super(key: key);

  @override
  State<DetalhesClienteScreen> createState() => _DetalhesClienteScreenState();
}

class _DetalhesClienteScreenState extends State<DetalhesClienteScreen> {
  late Future<Cliente> _clienteFuture;

  @override
  void initState() {
    super.initState();
    _clienteFuture = _buscarCliente(widget.clienteId);
  }

  Future<Cliente> _buscarCliente(int id) async {
    final url = Uri.parse('http://192.168.3.37:8000/api/crudclientes/$id/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Cliente.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao buscar cliente: ${response.statusCode}');
    }
  }

  String formatarData(dynamic data) {
    if (data == null) return '-';
    if (data is DateTime) {
      return DateFormat('dd/MM/yyyy').format(data);
    }
    if (data is String && data.isNotEmpty) {
      try {
        final dt = DateTime.parse(data);
        return DateFormat('dd/MM/yyyy').format(dt);
      } catch (_) {
        return data;
      }
    }
    return data.toString();
  }

  String exibirValor(dynamic valor) {
    if (valor == null) return '-';
    if (valor is bool) return valor ? 'Sim' : 'Não';
    if (valor is int || valor is double) return valor.toString();
    return valor.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Cliente'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Cliente>(
        future: _clienteFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Cliente não encontrado."));
          }

          final cliente = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  cliente.nome,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildInfo("CPF", exibirValor(cliente.cpf)),
                _buildInfo("Email", exibirValor(cliente.email)),
                _buildInfo("Telefone", exibirValor(cliente.telefone)),
                _buildInfo("Endereço", exibirValor(cliente.endereco)),
                _buildInfo("Profissão", exibirValor(cliente.profissao)),
                _buildInfo("RG/RNE", exibirValor(cliente.rgrne)),
                _buildInfo("Data de Nascimento", formatarData(cliente.data_nascimento)),
                _buildInfo("Score", exibirValor(cliente.score)),
                const Divider(),
                const Text('Residente', style: TextStyle(fontWeight: FontWeight.bold)),
                _buildInfo("Nome", exibirValor(cliente.nomeresidente)),
                _buildInfo("CPF", exibirValor(cliente.cpfresidente)),
                _buildInfo("RG", exibirValor(cliente.rgresidente)),
                _buildInfo("Endereço", exibirValor(cliente.enderecoresidente)),
                _buildInfo("Profissão", exibirValor(cliente.profissaoresidente)),
                _buildInfo("Estado Civil", exibirValor(cliente.estadocivilresidente)),
                _buildInfo("Celular", exibirValor(cliente.celularresidente)),
                _buildInfo("Email", exibirValor(cliente.emailresidente)),
                const Divider(),
                const Text('Contrato / Unidade', style: TextStyle(fontWeight: FontWeight.bold)),
                _buildInfo("Consultor", exibirValor(cliente.consultor)),
                _buildInfo("Condomínio", exibirValor(cliente.condominio)),
                _buildInfo("Apartamento", exibirValor(cliente.apto)),
                _buildInfo("Matrícula", exibirValor(cliente.matriculaunidade)),
                _buildInfo("Vagas", exibirValor(cliente.vagaunidade)),
                _buildInfo("Endereço da Unidade", exibirValor(cliente.enderecounidade)),
                _buildInfo("IPTU", exibirValor(cliente.nriptuunidade)),
                _buildInfo("Valor", exibirValor(cliente.vrunidade)),
                _buildInfo("Início Contrato", formatarData(cliente.iniciocontrato)),
                _buildInfo("Prazo do Contrato", exibirValor(cliente.prazocontrato)),
                _buildInfo("Isenção Multa", exibirValor(cliente.isencaomulta)),
                _buildInfo("% Desconto", exibirValor(cliente.percentualdesconto)),
                _buildInfo("Início Desconto", formatarData(cliente.datainiciodesconto)),
                _buildInfo("Término Desconto", formatarData(cliente.dataterminodesconto)),
                _buildInfo("Observações", exibirValor(cliente.observacoes)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
