import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clientes_app/services/databusca_service.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
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
  final _enderecoController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _nomeResidenteController = TextEditingController();
  final _cpfResidenteController = TextEditingController();
  final _rgResidenteController = TextEditingController();
  final _enderecoResidenteController = TextEditingController();
  final _profissaoResidenteController = TextEditingController();
  final _estadoCivilResidenteController = TextEditingController();
  final _celularResidenteController = TextEditingController();
  final _emailResidenteController = TextEditingController();
  final _consultorController = TextEditingController();
  final _condominioController = TextEditingController();
  final _matriculaController = TextEditingController();
  final _vagasController = TextEditingController();
  final _enderecoUnidadeController = TextEditingController();
  final _iptuController = TextEditingController();
  final _valorController = TextEditingController();
  final _inicioContratoController = TextEditingController();
  final _prazoContratoController = TextEditingController();
  final _percentualDescontoController = TextEditingController();
  final _dataInicioDescontoController = TextEditingController();
  final _dataTerminoDescontoController = TextEditingController();
  final _observacoesController = TextEditingController();

  bool _isSalvando = false;
  bool _isencaoMulta = false;

  String? _estadoCivilSelecionado;
  final List<String> _opcoesEstadoCivil = [
    'Solteiro(a)',
    'Casado(a)',
    'Divorciado(a)',
    'Viúvo(a)',
    'Separado(a) judicialmente',
  ];

  final _cpfFormatter = MaskTextInputFormatter(mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  final _telefoneFormatter = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  final _dataFormatter = MaskTextInputFormatter(mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
  final _valorFormatter = MaskTextInputFormatter(mask: '#######.##', filter: {"#": RegExp(r'[0-9]')});

  Future<void> _selecionarData(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  Future<void> _consultarCpf() async {
    final cpf = _cpfController.text.replaceAll(RegExp(r'[^0-9]'), '');
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
        _scoreController.text = d['CreditScore']?['D00']?.toString() ?? '0';
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
    _enderecoController.dispose();
    _dataNascimentoController.dispose();
    _nomeResidenteController.dispose();
    _cpfResidenteController.dispose();
    _rgResidenteController.dispose();
    _enderecoResidenteController.dispose();
    _profissaoResidenteController.dispose();
    _estadoCivilResidenteController.dispose();
    _celularResidenteController.dispose();
    _emailResidenteController.dispose();
    _consultorController.dispose();
    _condominioController.dispose();
    _matriculaController.dispose();
    _vagasController.dispose();
    _enderecoUnidadeController.dispose();
    _iptuController.dispose();
    _valorController.dispose();
    _inicioContratoController.dispose();
    _prazoContratoController.dispose();
    _percentualDescontoController.dispose();
    _dataInicioDescontoController.dispose();
    _dataTerminoDescontoController.dispose();
    _observacoesController.dispose();
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
                    child: TextFormField(
                      controller: _cpfController,
                      inputFormatters: [_cpfFormatter],
                      decoration: const InputDecoration(labelText: 'CPF'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value == null || value.length < 11 ? 'CPF inválido' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _consultarCpf,
                    icon: const Icon(Icons.search),
                    label: const Text("Consultar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(_nomeController, 'Nome'),
              _buildTextField(_profissaoController, 'Profissão'),
              _buildDropdownEstadoCivil(),
              _buildTextField(_rgRneController, 'RG/RNE'),
              _buildTextField(_emailController, 'Email', keyboardType: TextInputType.emailAddress),
              _buildTextField(_telefoneController, 'Telefone', inputFormatters: [_telefoneFormatter], keyboardType: TextInputType.phone),
              _buildTextField(_enderecoController, 'Endereço'),
              _buildDateField(context, _dataNascimentoController, 'Data de Nascimento'),
              _buildTextField(_aptoController, 'Apartamento'),
              _buildTextField(_scoreController, 'Score'),
              const Divider(),
              const Text('Dados do Residente', style: TextStyle(fontWeight: FontWeight.bold)),
              _buildTextField(_nomeResidenteController, 'Nome do Residente'),
              _buildTextField(_cpfResidenteController, 'CPF do Residente', inputFormatters: [_cpfFormatter]),
              _buildTextField(_rgResidenteController, 'RG do Residente'),
              _buildTextField(_enderecoResidenteController, 'Endereço do Residente'),
              _buildTextField(_profissaoResidenteController, 'Profissão do Residente'),
              _buildTextField(_estadoCivilResidenteController, 'Estado Civil do Residente'),
              _buildTextField(_celularResidenteController, 'Celular do Residente', inputFormatters: [_telefoneFormatter]),
              _buildTextField(_emailResidenteController, 'Email do Residente'),
              const Divider(),
              const Text('Unidade e Contrato', style: TextStyle(fontWeight: FontWeight.bold)),
              _buildTextField(_consultorController, 'Consultor'),
              _buildTextField(_condominioController, 'Condomínio'),
              _buildTextField(_matriculaController, 'Matrícula'),
              _buildTextField(_vagasController, 'Vagas'),
              _buildTextField(_enderecoUnidadeController, 'Endereço da Unidade'),
              _buildTextField(_iptuController, 'Número do IPTU'),
              _buildTextField(_valorController, 'Valor', inputFormatters: [_valorFormatter], keyboardType: TextInputType.number),
              _buildDateField(context, _inicioContratoController, 'Início do Contrato'),
              _buildTextField(_prazoContratoController, 'Prazo do Contrato'),
              SwitchListTile(
                title: const Text('Isenção de Multa'),
                value: _isencaoMulta,
                onChanged: (value) => setState(() => _isencaoMulta = value),
              ),
              _buildTextField(_percentualDescontoController, 'Percentual de Desconto'),
              _buildDateField(context, _dataInicioDescontoController, 'Data de Início do Desconto'),
              _buildDateField(context, _dataTerminoDescontoController, 'Data de Término do Desconto'),
              _buildTextField(_observacoesController, 'Observações', maxLines: 3),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSalvando ? null : () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white,),
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

  Widget _buildTextField(TextEditingController controller, String label, {
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _buildDateField(BuildContext context, TextEditingController controller, String label) {
    return GestureDetector(
      onTap: () => _selecionarData(context, controller),
      child: AbsorbPointer(
        child: _buildTextField(
          controller,
          label,
          keyboardType: TextInputType.datetime,
          inputFormatters: [_dataFormatter],
        ),
      ),
    );
  }

  Widget _buildDropdownEstadoCivil() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: _estadoCivilSelecionado,
        decoration: const InputDecoration(labelText: 'Estado Civil'),
        items: _opcoesEstadoCivil.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) => setState(() => _estadoCivilSelecionado = value),
        validator: (value) => value == null ? 'Campo obrigatório' : null,
      ),
    );
  }

}