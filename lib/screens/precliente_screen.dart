import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/precliente.dart';
import '../services/precliente_service.dart';
import 'preclientedetalhe_screen.dart';
import 'preclienteeditar_screen.dart';
import 'preclientenovo_screen.dart';


class PreclientesScreen extends StatefulWidget {
  const PreclientesScreen({super.key});

  @override
  State<PreclientesScreen> createState() => _PreclientesScreenState();
}

class _PreclientesScreenState extends State<PreclientesScreen> {
  late Future<List<Precliente>> _preclientesFuture;

  @override
  void initState() {
    super.initState();
    _preclientesFuture = PreclienteService.fetchPreclientes();
  }

  void _recarregar() {
    setState(() {
      _preclientesFuture = PreclienteService.fetchPreclientes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pré-Clientes", style: GoogleFonts.poppins()),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Precliente>>(
        future: _preclientesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum pré-cliente encontrado."));
          } else {
            final preclientes = snapshot.data!;
            return ListView.builder(
              itemCount: preclientes.length,
              itemBuilder: (context, index) {
                final precliente = preclientes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          precliente.preclienteNome,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text("Email: ${precliente.precoclienteEmail}"),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _botaoAcao("Consultar", Icons.search, Colors.blue, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PreclienteDetalhesScreen(precliente: precliente),
                                ),
                              );
                            }),

                            _botaoAcao("Editar", Icons.edit, Colors.orange, () async {
                              final atualizado = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PreclienteEditarScreen(precliente: precliente),
                                ),
                              );

                              if (atualizado == true) {
                                _recarregar();
                              }
                            }),

                            _botaoAcao("Transformar em Cliente", Icons.person_add, Colors.green, () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("${ precliente.preclienteNome} foi convertido em cliente!")),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final cadastrado = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PreclienteNovoScreen()),
          );
          if (cadastrado == true) {
            _recarregar();
          }
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
        tooltip: 'Adicionar Pré-Cliente',
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
}
