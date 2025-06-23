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
}
