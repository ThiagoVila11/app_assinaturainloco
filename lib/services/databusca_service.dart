import 'dart:convert';
import 'package:http/http.dart' as http;

class APIDataBuscaService {
  static const String _loginUrl = 'https://api.ph3a.com.br/DataBusca/api/Account/Login';
  static const String _dataUrl = 'https://api.ph3a.com.br/DataBusca/data';

  // Coloque seu usuário e senha da PH3A aqui
  static const String _usuario = 'dev@reda.one';
  static const String _senha = r'REDA@#$%Summer22';

  static Future<String> _getAuthToken() async {
    final payload = {
      "UserName": _usuario,
      "Password": _senha,
    };

    final headers = {
      "Authorization": "Basic ${base64Encode(utf8.encode(_usuario))}",
      "Content-Type": "application/json",
    };

    final response = await http.post(Uri.parse(_loginUrl), headers: headers, body: jsonEncode(payload));
    //print("token response: ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return data['data']['Token'];
      } else {
        throw Exception('Autenticação falhou');
      }
    } else {
      throw Exception('Erro ao autenticar: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> buscarPorCpf(String cpf) async {
    final token = await _getAuthToken();
    //print(cpf);
    final headers = {
      "Content-Type": "application/json",
      "Token": token,
    };
    //print("headers: $headers");
    final body = {
      "Document": cpf,
    };
    //print("body: $body");
    final response = await http.post(Uri.parse(_dataUrl), headers: headers, body: jsonEncode(body));
    //print("response cpf: ${response.body}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar dados: ${response.statusCode} - ${response.body}');
    }
  }
}
