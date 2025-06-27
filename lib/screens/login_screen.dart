import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    final url = Uri.parse('http://192.168.3.37:8001/api/login/'); // use IP real no dispositivo físico
    final body = jsonEncode({'username': username, 'password': password});
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      print('Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final urlvalidar = Uri.parse('http://192.168.3.37:8001/api/usuario-por-email/?nomeusuario=${username}');
        final responseValidar = await http.get(
            urlvalidar,
            headers: {'Content-Type': 'application/json'},
        );
        print(responseValidar.body);
        if (responseValidar.statusCode == 200) {
          final usuarioData = jsonDecode(responseValidar.body);
          final usuarioEmail = usuarioData['usuarioEmail'];
          // Salva os dados do usuário na sessão
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('usuarioNome', usuarioData['usuarioNome']);
          await prefs.setString('usuarioEmail', usuarioData['usuarioEmail']);
          await prefs.setString('usuarioFuncao', usuarioData['usuarioFuncao']);
          await prefs.setInt('usuarioId', usuarioData['id']);

          final urlconsultor = Uri.parse('http://192.168.3.37:8000/api/consultor/?email=${usuarioEmail}');
          final responseconsultor = await http.get(
              urlconsultor,
              headers: {'Content-Type': 'application/json'},
          );
          if (responseconsultor.statusCode == 200) {
            final consultorData = jsonDecode(responseconsultor.body);
            // Salva os dados do consultor na sessão
            final prefs = await SharedPreferences.getInstance();
            await prefs.setInt('consultorId', consultorData['id']);
          } else {
            print('Erro ao buscar dados do consultor: ${responseconsultor.statusCode}');
          }

        } else {
          print('Erro ao buscar dados do usuário: ${responseValidar.statusCode}');
        }
        // Exemplo: salva token e id do usuário na sessão
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);

        Navigator.pushNamed(context, '/home');
      } else {
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário ou senha inválidos')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
      print('Erro ao fazer login: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Usuário',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Acessar'),
            ),
          ],
        ),
      ),
    );
  }
}
