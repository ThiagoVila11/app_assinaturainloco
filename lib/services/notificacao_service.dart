import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notificacao.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NotificacaoService {
  static Future<List<Notificacao>> fetchNotificacoes() async {
    final prefs = await SharedPreferences.getInstance();
    final consultorId = prefs.getInt('consultorId');

    if (consultorId == null) {
      throw Exception('Usuário não logado.');
    }

    final String url = 'http://192.168.3.37:8000/api/$consultorId/notificacoes/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Notificacao.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar notificações');
    }
  }
}
