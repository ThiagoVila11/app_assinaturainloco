import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/notificacao.dart';
import '../services/notificacao_service.dart';

class NotificacoesScreen extends StatefulWidget {
  const NotificacoesScreen({super.key});

  @override
  State<NotificacoesScreen> createState() => _NotificacoesScreenState();
}

class _NotificacoesScreenState extends State<NotificacoesScreen> {
  late Future<List<Notificacao>> _notificacoes;

  @override
  void initState() {
    super.initState();
    _notificacoes = NotificacaoService.fetchNotificacoes();
  }

  String formatDate(DateTime data) {
    return DateFormat('dd/MM/yyyy HH:mm', 'pt_BR').format(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notificações")),
      body: FutureBuilder<List<Notificacao>>(
        future: _notificacoes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma notificação encontrada.'));
          } else {
            final notificacoes = snapshot.data!;
            return ListView.builder(
              itemCount: notificacoes.length,
              itemBuilder: (context, index) {
                final n = notificacoes[index];
                return ListTile(
                  leading: Icon(n.lido ? Icons.notifications : Icons.notifications_active),
                  title: Text(n.titulo),
                  subtitle: Text(formatDate(n.data)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(n.titulo),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Data: ${formatDate(n.data)}'),
                            const SizedBox(height: 10),
                            Text('Descrição:'),
                            SelectableText(n.descricao),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: const Text("Fechar"),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
