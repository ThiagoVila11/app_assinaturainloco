import 'package:flutter/material.dart';
import 'clientes_screen.dart';
import 'agenda_screen.dart';
import 'notificacoes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDarkMode = false;

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
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildUserHeader(),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Clientes'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ClientesScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Agenda'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AgendaScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notificações'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const NotificacoesScreen()));
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
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Você saiu (simulação).")));
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
      accountName: const Text("Evandro Ragonha"),
      accountEmail: const Text("evandro@vila11.com.br"),
      currentAccountPicture: const CircleAvatar(
        backgroundImage: NetworkImage(
            'https://avatars.githubusercontent.com/u/583231?v=4'), // GitHub Octocat
      ),
    );
  }
}
