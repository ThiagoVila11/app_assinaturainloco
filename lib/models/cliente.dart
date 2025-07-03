class Cliente {
  final int id;
  final String nome;
  final String cpf;
  final String profissao;
  final String estcivil;
  final String rgrne;
  final String email;
  final String telefone;
  final String endereco;
  final DateTime data_nascimento;
  final String observacoes;
  final DateTime data_cadastro;
  final String nomeresidente;
  final String cpfresidente;
  final String rgresidente;
  final String? enderecoresidente;
  final String? profissaoresidente;
  final String estadocivilresidente;
  final String celularresidente;
  final String emailresidente;
  final String score;
  final String unidade;
  final String apto;
  final String nomeunidade;
  final String cnpjunidade;
  final String matriculaunidade;
  final String vagaunidade;
  final String enderecounidade;
  final String nriptuunidade;
  final String vrunidade;
  final String prazocontrato;
  final DateTime iniciocontrato;
  final DateTime? terminocontrato;
  final bool visitarealizada;
  final String? documentacaoenviada;
  final int? condominio;
  final String? apartamento;
  final int? consultor;
  final int? preCliente;
  final String? percentualdesconto;
  final DateTime? datainiciodesconto;
  final DateTime? dataterminodesconto;
  final bool isencaomulta;
  final bool documentacaoassinada;
  final DateTime? datahoraassinatura;
  final String statusassinatura;
  final int? processoAssinaturaId;
  final String enderecoWebhook;
  final bool processofinalizado;

  Cliente({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.profissao,
    required this.estcivil,
    required this.rgrne,
    required this.email,
    required this.telefone,
    required this.endereco,
    required this.data_nascimento,
    required this.observacoes,
    required this.data_cadastro,
    required this.nomeresidente,
    required this.cpfresidente,
    required this.rgresidente,
    required this.enderecoresidente,
    required this.profissaoresidente,
    required this.estadocivilresidente,
    required this.celularresidente,
    required this.emailresidente,
    required this.score,
    required this.unidade,
    required this.apto,
    required this.nomeunidade,
    required this.cnpjunidade,
    required this.matriculaunidade,
    required this.vagaunidade,
    required this.enderecounidade,
    required this.nriptuunidade,
    required this.vrunidade,
    required this.prazocontrato,
    required this.iniciocontrato,
    required this.terminocontrato,
    required this.visitarealizada,
    required this.documentacaoenviada,
    required this.condominio,
    required this.apartamento,
    required this.consultor,
    required this.preCliente,
    required this.percentualdesconto,
    required this.datainiciodesconto,
    required this.dataterminodesconto,
    required this.isencaomulta,
    required this.documentacaoassinada,
    required this.datahoraassinatura,
    required this.statusassinatura,
    required this.processoAssinaturaId,
    required this.enderecoWebhook,
    required this.processofinalizado,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      cpf: json['cpf'] ?? '',
      profissao: json['profissao'] ?? '',
      estcivil: json['estcivil'] ?? '',
      rgrne: json['rgrne'] ?? '',
      email: json['email'] ?? '',
      telefone: json['telefone'] ?? '',
      endereco: json['endereco'] ?? '',
      data_nascimento: DateTime.tryParse(json['data_nascimento'] ?? '') ?? DateTime(1970),
      observacoes: json['observacoes'] ?? '',
      data_cadastro: DateTime.tryParse(json['data_cadastro'] ?? '') ?? DateTime(1970),
      nomeresidente: json['nomeresidente'] ?? '',
      cpfresidente: json['cpfresidente'] ?? '',
      rgresidente: json['rgresidente'] ?? '',
      enderecoresidente: json['enderecoresidente']?.toString(),
      profissaoresidente: json['profissaoresidente']?.toString(),
      estadocivilresidente: json['estadocivilresidente'] ?? '',
      celularresidente: json['celularresidente'] ?? '',
      emailresidente: json['emailresidente'] ?? '',
      score: json['score']?.toString() ?? '',
      unidade: json['unidade'] ?? '',
      apto: json['apto']?.toString() ?? '',
      nomeunidade: json['nomeunidade'] ?? '',
      cnpjunidade: json['cnpjunidade'] ?? '',
      matriculaunidade: json['matriculaunidade'] ?? '',
      vagaunidade: json['vagaunidade']?.toString() ?? '',
      enderecounidade: json['enderecounidade'] ?? '',
      nriptuunidade: json['nriptuunidade'] ?? '',
      vrunidade: json['vrunidade']?.toString() ?? '',
      prazocontrato: json['prazocontrato']?.toString() ?? '',
      iniciocontrato: DateTime.tryParse(json['iniciocontrato'] ?? '') ?? DateTime(1970),
      terminocontrato: json['terminocontrato'] != null
          ? DateTime.tryParse(json['terminocontrato'])
          : null,
      visitarealizada: json['visitarealizada'] ?? false,
      documentacaoenviada: json['documentacaoenviada']?.toString(),
      condominio: json['Condominio'],
      apartamento: json['Apartamento']?.toString(),
      consultor: json['Consultor'],
      preCliente: json['PreCliente'],
      percentualdesconto: json['percentualdesconto']?.toString(),
      datainiciodesconto: json['datainiciodesconto'] != null
          ? DateTime.tryParse(json['datainiciodesconto'])
          : null,
      dataterminodesconto: json['dataterminodesconto'] != null
          ? DateTime.tryParse(json['dataterminodesconto'])
          : null,
      isencaomulta: json['isencaomulta'] ?? false,
      documentacaoassinada: json['documentacaoassinada'] ?? false,
      datahoraassinatura: json['datahoraassinatura'] != null
          ? DateTime.tryParse(json['datahoraassinatura'])
          : null,
      statusassinatura: json['statusassinatura'] ?? '',
      processoAssinaturaId: json['processoassinaturaid'],
      enderecoWebhook: json['enderecowebhook'] ?? '',
      processofinalizado: json['processofinalizado'] ?? false,
    );
  }
}