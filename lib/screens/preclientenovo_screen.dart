import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/databusca_service.dart';

class PreclienteNovoScreen extends StatefulWidget {
  const PreclienteNovoScreen({super.key});

  @override
  State<PreclienteNovoScreen> createState() => _PreclienteNovoScreenState();
}

class _PreclienteNovoScreenState extends State<PreclienteNovoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _emailController = TextEditingController();
  final _scoreController = TextEditingController();
  final _apontamentosController = TextEditingController();
  final _rendaPresumidaController = TextEditingController();
  final _rendaFamiliarController = TextEditingController();
  final _avalAutoController = TextEditingController();
  final _avaliacaoController = TextEditingController();
  final _jsonController = TextEditingController();

  DateTime? _dataVisita;
  bool _salvando = false;

  List<Map<String, dynamic>> _listaCondominios = [];
  int? _condominioSelecionado;
  int? _consultorId;

  @override
  void initState() {
    super.initState();
    _carregarCondominios();
    _carregarConsultor();
  }

  Future<void> _carregarCondominios() async {
    final url = Uri.parse('http://192.168.3.37:8000/api/condominios/');
    final response = await http.get(url);
    print("response condominios: ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _listaCondominios = List<Map<String, dynamic>>.from(data);
      });
    } else {
      print('Erro ao carregar condomínios: ${response.statusCode}');
    }
  }

  Future<void> _carregarConsultor() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _consultorId = prefs.getInt('consultorId');
    });
  }

  Future<void> _consultarCpf() async {
    final cpf = _cpfController.text.trim();
    if (cpf.isEmpty) return;

    try {
      final data = await APIDataBuscaService.buscarPorCpf(cpf);
      final d = data['Data'];

      String obs = '';
      if (d['ActiveDebts'] != null && d['ActiveDebts'].isNotEmpty) {
        final debito = d['ActiveDebts'][0];
        final categoria = debito["CategoryName"] ?? '';
        final descr = debito["Description"] ?? '';
        final valores = debito["EntryValue"] ?? '';
        if (categoria.isNotEmpty) {
          obs = "$categoria / $descr / $valores";
        }
      }

      setState(() {
        _nomeController.text = d['NameBrasil'] ?? '';
        _scoreController.text = d['CreditScore']['D00']?.toString() ?? '';
        _emailController.text = (d['Emails'] is List && d['Emails'].isNotEmpty) ? d['Emails'][0]['Email'] ?? '' : '';
        _apontamentosController.text = obs;
        _rendaPresumidaController.text = d['Income']['Presumed']?.toString() ?? '';
        _rendaFamiliarController.text = d['Income']['Family']?.toString() ?? '';
        _jsonController.text = jsonEncode(d);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Dados carregados com sucesso.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao buscar dados: $e")),
      );
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    if (_consultorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Consultor não identificado.")),
      );
      setState(() => _salvando = false);
      return;
    }

    final url = Uri.parse('http://192.168.3.37:8000/api/preclientes/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "preclienteNome": _nomeController.text.trim(),
        "preclienteCpf": _cpfController.text.trim(),
        "precoclienteEmail": _emailController.text.trim(),
        "preclienteDataCadastro": DateTime.now().toIso8601String(),
        "preclienteScore": _scoreController.text.trim(),
        "preclienteApontamentos": _apontamentosController.text.trim(),
        "preclienteRendaPresumida": _rendaPresumidaController.text.trim(),
        "preclienteRendaFamiliar": _rendaFamiliarController.text.trim(),
        "preclienteAvalAuto": _avalAutoController.text.trim(),
        "preclienteAvaliacao": _avaliacaoController.text.trim(),
        "preclienteJson": _jsonController.text.trim(),
        "preclienteDataVisita": _dataVisita != null ? _dataVisita!.toIso8601String().split('T')[0] : null,
        "preclienteCondominio": _condominioSelecionado,
        "Consultor": _consultorId,
      }),
    );

    setState(() => _salvando = false);

    if (response.statusCode == 201) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pré-cliente cadastrado com sucesso!")),
        );
        Navigator.of(context).pop(true);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: ${response.body}")),
      );
    }
  }

  Future<void> _selecionarDataVisita() async {
    final DateTime? data = await showDatePicker(
      context: context,
      initialDate: _dataVisita ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (data != null) {
      setState(() => _dataVisita = data);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _emailController.dispose();
    _scoreController.dispose();
    _apontamentosController.dispose();
    _rendaPresumidaController.dispose();
    _rendaFamiliarController.dispose();
    _avalAutoController.dispose();
    _avaliacaoController.dispose();
    _jsonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo Pré-Cliente"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _campoTexto("CPF", _cpfController),
              TextButton.icon(
                icon: const Icon(Icons.search),
                label: const Text("Consultar CPF"),
                onPressed: _consultarCpf,
              ),
              _campoTexto("Nome", _nomeController),
              _campoTexto("Email", _emailController),
              _campoTexto("Score", _scoreController),
              _campoTexto("Apontamentos", _apontamentosController, obrigatorio: false),
              _campoTexto("Renda Presumida", _rendaPresumidaController),
              _campoTexto("Renda Familiar", _rendaFamiliarController),
              if (_consultorId != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    initialValue: _consultorId.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Consultor',
                      border: OutlineInputBorder(),
                    ),
                    enabled: false,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Condomínio',
                    border: OutlineInputBorder(),
                  ),
                  value: _condominioSelecionado,
                  items: _listaCondominios.map((cond) {
                    return DropdownMenuItem<int>(
                      value: cond['id'],
                      child: Text(cond['condominionome'] ?? 'Sem nome'),
                    );
                  }).toList(),
                  onChanged: (int? novoValor) {
                    setState(() {
                      _condominioSelecionado = novoValor;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Selecione um condomínio' : null,
                ),
              ),
              const SizedBox(height: 12),
              Text("Data da Visita: ${_dataVisita != null ? _dataVisita!.toLocal().toString().split(" ")[0] : 'Nenhuma selecionada'}"),
              TextButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: const Text("Selecionar Data"),
                onPressed: _selecionarDataVisita,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: _salvando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Salvar"),
                onPressed: _salvando ? null : _salvar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoTexto(String label, TextEditingController controller, {bool obrigatorio = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: obrigatorio
            ? (value) => value == null || value.isEmpty ? "Campo obrigatório" : null
            : null,
      ),
    );
  }
}
