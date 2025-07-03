import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/cliente.dart';

class EditarClienteScreen extends StatefulWidget {
  final Cliente cliente;

  const EditarClienteScreen({super.key, required this.cliente});

  @override
  State<EditarClienteScreen> createState() => _EditarClienteScreenState();
}

class _EditarClienteScreenState extends State<EditarClienteScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nome = TextEditingController(text: widget.cliente.nome);
  late final TextEditingController _cpf = TextEditingController(text: widget.cliente.cpf);
  late final TextEditingController _profissao = TextEditingController(text: widget.cliente.profissao);
  late final TextEditingController _estcivil = TextEditingController(text: widget.cliente.estcivil);
  late final TextEditingController _rgrne = TextEditingController(text: widget.cliente.rgrne);
  late final TextEditingController _email = TextEditingController(text: widget.cliente.email);
  late final TextEditingController _telefone = TextEditingController(text: widget.cliente.telefone);
  late final TextEditingController _endereco = TextEditingController(text: widget.cliente.endereco);
  late final TextEditingController _dataNascimento = TextEditingController(text: formatarData(widget.cliente.data_nascimento));
  late final TextEditingController _score = TextEditingController(text: widget.cliente.score);

  // Residente
  late final TextEditingController _nomeresidente = TextEditingController(text: widget.cliente.nomeresidente);
  late final TextEditingController _cpfresidente = TextEditingController(text: widget.cliente.cpfresidente);
  late final TextEditingController _rgresidente = TextEditingController(text: widget.cliente.rgresidente);
  late final TextEditingController _enderecoresidente = TextEditingController(text: widget.cliente.enderecoresidente ?? '');
  late final TextEditingController _profissaoresidente = TextEditingController(text: widget.cliente.profissaoresidente ?? '');
  late final TextEditingController _estadocivilresidente = TextEditingController(text: widget.cliente.estadocivilresidente);
  late final TextEditingController _celularresidente = TextEditingController(text: widget.cliente.celularresidente);
  late final TextEditingController _emailresidente = TextEditingController(text: widget.cliente.emailresidente);

  // Unidade/Contrato
  late final TextEditingController _consultor = TextEditingController(text: widget.cliente.consultor?.toString() ?? '');
  late final TextEditingController _condominio = TextEditingController(text: widget.cliente.condominio?.toString() ?? '');
  late final TextEditingController _apto = TextEditingController(text: widget.cliente.apto);
  late final TextEditingController _matricula = TextEditingController(text: widget.cliente.matriculaunidade);
  late final TextEditingController _vagas = TextEditingController(text: widget.cliente.vagaunidade);
  late final TextEditingController _enderecoUnidade = TextEditingController(text: widget.cliente.enderecounidade);
  late final TextEditingController _iptu = TextEditingController(text: widget.cliente.nriptuunidade);
  late final TextEditingController _valor = TextEditingController(text: widget.cliente.vrunidade);
  late final TextEditingController _prazoContrato = TextEditingController(text: widget.cliente.prazocontrato.toString());
  late final TextEditingController _inicioContrato = TextEditingController(text: formatarData(widget.cliente.iniciocontrato));
  late final TextEditingController _percentualDesconto = TextEditingController(text: widget.cliente.percentualdesconto ?? '');
  late final TextEditingController _dataInicioDesconto = TextEditingController(text: formatarData(widget.cliente.datainiciodesconto));
  late final TextEditingController _dataTerminoDesconto = TextEditingController(text: formatarData(widget.cliente.dataterminodesconto));
  late final TextEditingController _observacoes = TextEditingController(text: widget.cliente.observacoes);

  bool _isencaoMulta = false;

  @override
  void initState() {
    super.initState();
    _isencaoMulta = widget.cliente.isencaomulta ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Cliente'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTextField(_nome, 'Nome'),
            _buildTextField(_cpf, 'CPF'),
            _buildTextField(_profissao, 'Profissão'),
            _buildTextField(_estcivil, 'Estado Civil'),
            _buildTextField(_rgrne, 'RG/RNE'),
            _buildTextField(_email, 'Email'),
            _buildTextField(_telefone, 'Telefone'),
            _buildTextField(_endereco, 'Endereço'),
            _buildTextField(_dataNascimento, 'Data de Nascimento'),
            _buildTextField(_score, 'Score'),
            const Divider(),
            const Text('Dados do Residente', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildTextField(_nomeresidente, 'Nome do Residente'),
            _buildTextField(_cpfresidente, 'CPF do Residente'),
            _buildTextField(_rgresidente, 'RG do Residente'),
            _buildTextField(_enderecoresidente, 'Endereço do Residente'),
            _buildTextField(_profissaoresidente, 'Profissão do Residente'),
            _buildTextField(_estadocivilresidente, 'Estado Civil do Residente'),
            _buildTextField(_celularresidente, 'Celular do Residente'),
            _buildTextField(_emailresidente, 'Email do Residente'),
            const Divider(),
            const Text('Contrato / Unidade', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildTextField(_consultor, 'Consultor'),
            _buildTextField(_condominio, 'Condomínio'),
            _buildTextField(_apto, 'Apartamento'),
            _buildTextField(_matricula, 'Matrícula'),
            _buildTextField(_vagas, 'Vagas'),
            _buildTextField(_enderecoUnidade, 'Endereço da Unidade'),
            _buildTextField(_iptu, 'Número do IPTU'),
            _buildTextField(_valor, 'Valor'),
            _buildTextField(_inicioContrato, 'Início do Contrato'),
            _buildTextField(_prazoContrato, 'Prazo do Contrato'),
            SwitchListTile(
              title: const Text('Isenção de Multa'),
              value: _isencaoMulta,
              onChanged: (val) => setState(() => _isencaoMulta = val),
            ),
            _buildTextField(_percentualDesconto, 'Percentual de Desconto'),
            _buildTextField(_dataInicioDesconto, 'Data de Início do Desconto'),
            _buildTextField(_dataTerminoDesconto, 'Data de Término do Desconto'),
            _buildTextField(_observacoes, 'Observações', maxLines: 3),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _salvarEdicao,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

  String formatarData(DateTime? data) {
    if (data == null) return '';
    return DateFormat('yyyy-MM-dd').format(data);
  }

  void _salvarEdicao() async {
    if (!_formKey.currentState!.validate()) return;

    final url = Uri.parse('http://192.168.3.37:8000/api/crudclientes/${widget.cliente.id}/');
    final body = {
      'nome': _nome.text,
      'cpf': _cpf.text,
      'profissao': _profissao.text,
      'estcivil': _estcivil.text,
      'rgrne': _rgrne.text,
      'email': _email.text,
      'telefone': _telefone.text,
      'endereco': _endereco.text,
      'data_nascimento': _dataNascimento.text,
      'score': _score.text,
      'nomeresidente': _nomeresidente.text,
      'cpfresidente': _cpfresidente.text,
      'rgresidente': _rgresidente.text,
      'enderecoresidente': _enderecoresidente.text,
      'profissaoresidente': _profissaoresidente.text,
      'estadocivilresidente': _estadocivilresidente.text,
      'celularresidente': _celularresidente.text,
      'emailresidente': _emailresidente.text,
      'consultor': _consultor.text,
      'condominio': _condominio.text,
      'apto': _apto.text,
      'matriculaunidade': _matricula.text,
      'vagaunidade': _vagas.text,
      'enderecounidade': _enderecoUnidade.text,
      'nriptuunidade': _iptu.text,
      'vrunidade': _valor.text,
      'iniciocontrato': _inicioContrato.text,
      'prazocontrato': _prazoContrato.text,
      'isencaomulta': _isencaoMulta,
      'percentualdesconto': _percentualDesconto.text,
      'datainiciodesconto': _dataInicioDesconto.text,
      'dataterminodesconto': _dataTerminoDesconto.text,
      'observacoes': _observacoes.text,
    };

    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cliente atualizado com sucesso')),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: ${response.body}')),
      );
    }
  }
}
