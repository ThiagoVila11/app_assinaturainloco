class Notificacao {
  final int id;
  final String titulo;
  final String descricao;
  final DateTime data;
  final bool lido;

  Notificacao({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.data,
    required this.lido,
  });

  factory Notificacao.fromJson(Map<String, dynamic> json) {
    return Notificacao(
      id: json['id'],
      titulo: json['NotificacaoTitulo'],
      descricao: json['NotificacaoDescricao'],
      data: DateTime.parse(json['NotificacaoData']),
      lido: json['NotificacaoLido'] ?? false,
    );
  }
}
