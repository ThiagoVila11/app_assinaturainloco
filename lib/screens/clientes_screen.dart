import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/cliente.dart';
import '../services/api_service.dart';
import '../widgets/cliente_card.dart';

class ClientesScreen extends StatefulWidget {
  @override
  _ClientesScreenState createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  late Future<List<Cliente>> _clientesFuture;
  List<Cliente> _clientesFiltrados = [];
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _clientesFuture = _carregarClientes();
  }

  Future<List<Cliente>> _carregarClientes() async {
    List<Cliente> clientes = await ApiService.fetchClientes();

    // Ordena por score (decrescente)
    clientes.sort((a, b) => int.parse(b.score).compareTo(int.parse(a.score)));

    _clientesFiltrados = clientes;
    return clientes;
  }

  void _filtrarClientes(String query, List<Cliente> todosClientes) {
    setState(() {
      _searchText = query;
      _clientesFiltrados = todosClientes.where((cliente) {
        final nome = cliente.nome.toLowerCase();
        final cpf = cliente.cpf.replaceAll(RegExp(r'[\.\-]'), '').toLowerCase();
        final search = query.toLowerCase();
        return nome.contains(search) || cpf.contains(search);
      }).toList();
    });
  }

  void _recarregarClientes() {
    setState(() {
      _clientesFuture = _carregarClientes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clientes", style: GoogleFonts.poppins()),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Cliente>>(
        future: _clientesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum cliente encontrado."));
          } else {
            List<Cliente> todosClientes = snapshot.data!;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Pesquisar por nome ou CPF",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (value) => _filtrarClientes(value, todosClientes),
                  ),
                ),
                Expanded(
                  child: _clientesFiltrados.isEmpty
                      ? const Center(child: Text("Nenhum cliente encontrado."))
                      : ListView.builder(
                          itemCount: _clientesFiltrados.length,
                          itemBuilder: (context, index) {
                            return ClienteCard(
                              cliente: _clientesFiltrados[index],
                              onFinalizado: _recarregarClientes, // importante!
                            );
                          },
                        ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
