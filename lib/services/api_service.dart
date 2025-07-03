import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cliente.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.3.37:8000/api/clientes';

  static Future<List<Cliente>> fetchClientes() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Cliente.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar clientes');
    }
  }
  
  static Future<void> addCliente(Cliente cliente) async {
    final response = await http.post(
      Uri.parse('http://192.168.3.37:8000/api/clientes/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': cliente.nome,
        'cpf': cliente.cpf,
        'score': cliente.score,
        'profissao': cliente.profissao,
        'estcivil': cliente.estcivil,
        'rgrne': cliente.rgrne,
        'email': cliente.email,
        'telefone': cliente.telefone,
        'endereco': cliente.endereco,
        'data_nascimento': cliente.data_nascimento.toIso8601String(),
        'observacoes': cliente.observacoes,
        'data_cadastro': cliente.data_cadastro.toIso8601String(),
        'nomeresidente': cliente.nomeresidente,
        'cpfresidente': cliente.cpfresidente,
        'rgresidente': cliente.rgresidente,
        'enderecoresidente': cliente.enderecoresidente,
        'profissaoresidente': cliente.profissaoresidente,
        'estadocivilresidente': cliente.estadocivilresidente,
        'celularresidente': cliente.celularresidente,
        'emailresidente': cliente.emailresidente,
        'unidade': cliente.unidade,
        'apto': cliente.apto,
        'nomeunidade': cliente.nomeunidade,
        'cnpjunidade': cliente.cnpjunidade,
        'matriculaunidade': cliente.matriculaunidade,
        'vagaunidade': cliente.vagaunidade,
        'enderecounidade': cliente.enderecounidade,
        'nriptuunidade': cliente.nriptuunidade,
        'vrunidade': cliente.vrunidade,
        'prazocontrato': cliente.prazocontrato,
        'iniciocontrato': cliente.iniciocontrato.toIso8601String(),
        'terminocontrato': cliente.terminocontrato?.toIso8601String(),
        'visitarealizada': cliente.visitarealizada,
        'documentacaoenviada': cliente.documentacaoenviada,
        'condominio': cliente.condominio,
        'apartamento': cliente.apartamento,
        'consultor': cliente.consultor,
        'preCliente': cliente.preCliente,
        'percentualdesconto': cliente.percentualdesconto,
        'datainiciodesconto': cliente.datainiciodesconto?.toIso8601String(),
        'dataterminodesconto': cliente.dataterminodesconto?.toIso8601String(),
        'isencaomulta': cliente.isencaomulta,
        'documentacaoassinada': cliente.documentacaoassinada,
        'datahoraassinatura': cliente.datahoraassinatura?.toIso8601String(),
        'statusassinatura': cliente.statusassinatura,
        'processoAssinaturaId': cliente.processoAssinaturaId,
        'enderecoWebhook': cliente.enderecoWebhook,
        'processofinalizado': cliente.processofinalizado,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao adicionar cliente: ${response.body}');
    }
}

}



