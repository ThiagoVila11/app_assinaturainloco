import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/precliente.dart';

class PreclienteDetalhesScreen extends StatelessWidget {
  final Precliente precliente;

  const PreclienteDetalhesScreen({super.key, required this.precliente});

  @override
  Widget build(BuildContext context) {
    String formatarData(DateTime? data) {
      if (data == null) return 'Não informada';
      return DateFormat('dd/MM/yyyy HH:mm').format(data);
    }

    String formatarNumero(double? valor) {
      return valor != null ? valor.toStringAsFixed(2).replaceAll('.', ',') : '0,00';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Pré-Cliente'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _item("Nome", precliente.preclienteNome),
            _item("CPF", precliente.preclienteCpf),
            _item("Email", precliente.precoclienteEmail),
            _item("Data de Cadastro", formatarData(precliente.preclienteDataCadastro)),
            _item("Score", precliente.preclienteScore),
            _item("Apontamentos", precliente.preclienteApontamentos),
            _item("Renda Presumida", "R\$ ${formatarNumero(precliente.preclienteRendaPresumida)}"),
            _item("Renda Familiar", "R\$ ${formatarNumero(precliente.preclienteRendaFamiliar)}"),
            _item("Avaliação Automática", precliente.preclienteAvalAuto),
            _item("Avaliação", precliente.preclienteAvaliacao),
            _item("Data da Visita", formatarData(precliente.preclienteDataVisita)),
            _item("Condomínio", precliente.preclienteCondominio?.toString() ?? 'Não informado'),
            _item("Consultor", precliente.consultor.toString()),
          ],
        ),
      ),
    );
  }

  Widget _item(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(valor),
          ),
        ],
      ),
    );
  }
}
