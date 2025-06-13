class Cliente {
  final int id;
  final String nome;
  final String cpf;
  final String email;
  final int? condominio;
  final String apto;
  final String score;
  final int? consultor;
  final int? processoAssinaturaId;
  final String? enderecoWebhook;

  Cliente({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.email,
    required this.condominio,
    required this.apto,
    required this.score,
    required this.consultor,
    required this.processoAssinaturaId,
    required this.enderecoWebhook,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      cpf: json['cpf'] ?? '',
      email: json['email'] ?? '',
      condominio: json['Condominio'] ?? 0,
      apto: json['apto'] ?? '',
      score: json['score'] ?? '',
      consultor: json['Consultor'] ?? 0,
      processoAssinaturaId: json['processoassinaturaid'] ?? 0,
      enderecoWebhook: json['enderecowebhook'] ?? '',
    );
  }
}
