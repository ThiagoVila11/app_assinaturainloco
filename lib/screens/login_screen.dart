import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  bool senhaVisivel = false;

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Aqui você pode conectar com um backend futuramente
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Acesso ao sistema Vila11",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "E-mail",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Informe o e-mail" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: senhaController,
                      obscureText: !senhaVisivel,
                      decoration: InputDecoration(
                        labelText: "Senha",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(senhaVisivel
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              senhaVisivel = !senhaVisivel;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Informe a senha" : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, // muda a cor do texto
                        backgroundColor: Colors.deepPurple,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: _login,
                      icon: const Icon(Icons.login),
                      label: const Text("Entrar"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
