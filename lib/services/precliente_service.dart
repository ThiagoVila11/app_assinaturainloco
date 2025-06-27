import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/precliente.dart';

class PreclienteService {
  static Future<List<Precliente>> fetchPreclientes() async {
    final url = Uri.parse('http://192.168.3.37:8000/api/preclientes/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonList.map((json) => Precliente.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar pré-clientes: ${response.statusCode}');
    }
  }
}
