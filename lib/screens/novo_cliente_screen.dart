import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clientes_app/services/databusca_service.dart';
import '../services/api_service.dart';
import '../models/cliente.dart';

class NovoClienteScreen extends StatefulWidget {
  @override
  _NovoClienteScreenState createState() => _NovoClienteScreenState();
}

class _NovoClienteScreenState extends State<NovoClienteScreen> {
  final _formKey = GlobalKey<FormState>();

  final _cpfController = TextEditingController();
  final _nomeController = TextEditingController();
  final _profissaoController = TextEditingController();
  final _rgRneController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _aptoController = TextEditingController();
  final _scoreController = TextEditingController(text: '0');

  String? _estadoCivilSelecionado;
  bool _isSalvando = false;

  final List<String> _opcoesEstadoCivil = [
    'Solteiro(a)',
    'Casado(a)',
    'Divorciado(a)',
    'Viúvo(a)',
    'Separado(a) judicialmente',
  ];

  Future<void> _consultarCpf() async {
    final cpf = _cpfController.text.trim();
    if (cpf.isEmpty || cpf.length != 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Informe um CPF válido com 11 dígitos.")),
      );
      return;
    }

    try {
      final data = await APIDataBuscaService.buscarPorCpf(cpf);
      final d = data['Data'];

      setState(() {
        _nomeController.text = d['NameBrasil'] ?? '';
        _emailController.text = (d['Emails'] is List && d['Emails'].isNotEmpty)
            ? d['Emails'][0]['Email'] ?? ''
            : '';
        _telefoneController.text = '';
        _scoreController.text =
            d['CreditScore']?['D00']?.toString() ?? '0';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Dados do CPF carregados.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao buscar dados: $e")),
      );
    }
  }

  Future<void> _salvarCliente() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSalvando = true);

      Cliente novoCliente = Cliente(
        id: 0,
        nome: _nomeController.text.trim(),
        cpf: _cpfController.text.trim(),
        profissao: _profissaoController.text.trim(),
        estcivil: _estadoCivilSelecionado ?? 'Solteiro(a)',
        rgrne: _rgRneController.text.trim(),
        email: _emailController.text.trim(),
        telefone: _telefoneController.text.trim(),
        endereco: '',
        data_nascimento: DateTime.now(),
        observacoes: '',
        data_cadastro: DateTime.now(),
        nomeresidente: '',
        cpfresidente: '',
        rgresidente: '',
        enderecoresidente: '',
        profissaoresidente: '',
        estadocivilresidente: '',
        celularresidente: '',
        emailresidente: '',
        score: _scoreController.text.trim(),
        unidade: 'BEL',
        apto: _aptoController.text.trim(),
        nomeunidade: '',
        cnpjunidade: '',
        matriculaunidade: '',
        vagaunidade: '',
        enderecounidade: '',
        nriptuunidade: '',
        vrunidade: '',
        prazocontrato: '',
        iniciocontrato: DateTime.now(),
        terminocontrato: DateTime.now(),
        visitarealizada: null,
        documentacaoenviada: null,
        condominio: null,
        apartamento: null,
        consultor: null,
        preCliente: null,
        percentualdesconto: null,
        datainiciodesconto: null,
        dataterminodesconto: null,
        isencaomulta: false,
        documentacaoassinada: null,
        datahoraassinatura: null,
        statusassinatura: null,
        processoAssinaturaId: null,
        enderecoWebhook: null,
        processofinalizado: false,
      );

      try {
        await ApiService.addCliente(novoCliente);
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar cliente: $e')),
        );
      } finally {
        setState(() => _isSalvando = false);
      }
    }
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _nomeController.dispose();
    _profissaoController.dispose();
    _rgRneController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _aptoController.dispose();
    _scoreController.dispose();
    super.dispose();
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
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _cpfController,
                      decoration: const InputDecoration(labelText: 'CPF'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value == null || value.length != 11
                              ? 'CPF inválido'
                              : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _consultarCpf,
                      icon: const Icon(Icons.search),
                      label: const Text("Consultar"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _profissaoController,
                decoration: const InputDecoration(labelText: 'Profissão'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _estadoCivilSelecionado,
                items: _opcoesEstadoCivil.map((estado) {
                  return DropdownMenuItem(
                    value: estado,
                    child: Text(estado),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _estadoCivilSelecionado = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Estado Civil',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null ? 'Selecione o estado civil' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _rgRneController,
                decoration: const InputDecoration(labelText: 'RG/RNE'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _aptoController,
                decoration: const InputDecoration(labelText: 'Apartamento'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _scoreController,
                decoration: const InputDecoration(labelText: 'Score'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSalvando ? null : _salvarCliente,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: _isSalvando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
