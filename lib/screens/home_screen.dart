import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:badges/badges.dart' as badges;

import 'clientes_screen.dart';
import 'agenda_screen.dart';
import 'notificacoes_screen.dart';
import 'precliente_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDarkMode = false;

  String usuarioNome = '';
  String usuarioEmail = '';
  String usuarioFuncao = '';
  int consultorId = 0;
  int notificacoesPendentes = 0;

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  Future<void> _carregarDadosUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      usuarioNome = prefs.getString('usuarioNome') ?? '';
      usuarioEmail = prefs.getString('usuarioEmail') ?? '';
      usuarioFuncao = prefs.getString('usuarioFuncao') ?? '';
      consultorId = prefs.getInt('consultorId') ?? 0;
    });

    if (consultorId > 0) {
      _carregarNotificacoesPendentes();
    }
  }

  Future<void> _carregarNotificacoesPendentes() async {
    final url = Uri.parse('http://192.168.3.37:8000/api/$consultorId/notificacoes/');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final notificacoesNaoLidas = data.where((n) => n['lido'] == false).length;

        setState(() {
          notificacoesPendentes = notificacoesNaoLidas;
        });
      } else {
        print('Erro ao buscar notificações: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar notificações: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode
          ? ThemeData.dark().copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            )
          : ThemeData.light().copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Início'),
          actions: [
            badges.Badge(
              position: badges.BadgePosition.topEnd(top: 2, end: 2),
              showBadge: notificacoesPendentes > 0,
              badgeContent: Text(
                notificacoesPendentes.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications),
                tooltip: 'Notificações',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotificacoesScreen()),
                  ).then((_) => _carregarNotificacoesPendentes());
                },
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildUserHeader(),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Pré-Clientes'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PreclientesScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Clientes'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ClientesScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Agenda'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AgendaScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notificações'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotificacoesScreen()),
                  ).then((_) => _carregarNotificacoesPendentes());
                },
              ),
              const Divider(),
              SwitchListTile(
                secondary: const Icon(Icons.dark_mode),
                title: const Text('Modo Escuro'),
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sair'),
                onTap: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Você saiu (simulação).")),
                  );
                },
              ),
            ],
          ),
        ),
        body: const Center(
          child: Text(
            'Bem-vindo ao sistema Vila11!',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(color: Colors.deepPurple),
      accountName: Text(usuarioNome.isNotEmpty
          ? '$usuarioNome ($usuarioFuncao) ($consultorId)'
          : 'Usuário'),
      accountEmail: Text(usuarioEmail),
      currentAccountPicture: const CircleAvatar(
        backgroundImage: NetworkImage(
          'https://avatars.githubusercontent.com/u/583231?v=4',
        ),
      ),
    );
  }
}
