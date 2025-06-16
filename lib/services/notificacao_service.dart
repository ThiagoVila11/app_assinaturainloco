import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notificacao.dart';

class NotificacaoService {
  static const String url = 'https://inloco.vila11.com.br/api/notificacoes';

  static Future<List<Notificacao>> fetchNotificacoes() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Notificacao.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar notificações');
    }
  }
}
