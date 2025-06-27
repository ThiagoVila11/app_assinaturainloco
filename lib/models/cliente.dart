class Cliente {
  final int id;
  final String nome;
  final String cpf;
  final String email;
  final String telefone;
  final int? condominio;
  final String apto;
  final String score;
  final int? consultor;
  final int? processoAssinaturaId;
  final String? enderecoWebhook;
  final bool processofinalizado;

  Cliente({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.telefone,
    required this.email,
    required this.condominio,
    required this.apto,
    required this.score,
    required this.consultor,
    required this.processoAssinaturaId,
    required this.enderecoWebhook,
    required this.processofinalizado
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      cpf: json['cpf'] ?? '',
      email: json['email'] ?? '',
      telefone: json['telefone'] ?? '',
      condominio: json['Condominio'] ?? 0,
      apto: json['apto'] ?? '',
      score: json['score'] ?? '',
      consultor: json['Consultor'] ?? 0,
      processoAssinaturaId: json['processoassinaturaid'] ?? 0,
      enderecoWebhook: json['enderecowebhook'] ?? '',
      processofinalizado: json['processofinalizado'] ?? false,
    );
  }
}
