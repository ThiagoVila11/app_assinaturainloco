double? _toDouble(dynamic valor) {
  if (valor == null) return null;
  if (valor is double) return valor;
  if (valor is int) return valor.toDouble();
  if (valor is String) return double.tryParse(valor.replaceAll(',', '.'));
  return null;
}

class Precliente {
  final int id;
  final String preclienteNome;
  final String preclienteCpf;
  final String precoclienteEmail;
  final DateTime preclienteDataCadastro;
  final String preclienteScore;
  final String preclienteApontamentos;
  final double? preclienteRendaPresumida;
  final double? preclienteRendaFamiliar;
  final String preclienteAvalAuto;
  final String preclienteAvaliacao;
  final String preclienteJson;
  final DateTime? preclienteDataVisita;
  final int? preclienteCondominio;
  final int consultor;

  Precliente({
    required this.id,
    required this.preclienteNome,
    required this.preclienteCpf,
    required this.precoclienteEmail,
    required this.preclienteDataCadastro,
    required this.preclienteScore,
    required this.preclienteApontamentos,
    required this.preclienteRendaPresumida,
    required this.preclienteRendaFamiliar,
    required this.preclienteAvalAuto,
    required this.preclienteAvaliacao,
    required this.preclienteJson,
    required this.preclienteDataVisita,
    required this.preclienteCondominio,
    required this.consultor,
  });

  factory Precliente.fromJson(Map<String, dynamic> json) {
    return Precliente(
      id: json['id'],
      preclienteNome: json['preclienteNome'] ?? '',
      preclienteCpf: json['preclienteCpf'] ?? '',
      precoclienteEmail: json['precoclienteEmail'] ?? '',
      preclienteDataCadastro: DateTime.parse(json['preclienteDataCadastro']),
      preclienteScore: json['preclienteScore']?.toString() ?? '',
      preclienteApontamentos: json['preclienteApontamentos'] ?? '',
      preclienteRendaPresumida: _toDouble(json['preclienteRendaPresumida']),
      preclienteRendaFamiliar: _toDouble(json['preclienteRendaFamiliar']),
      preclienteAvalAuto: json['preclienteAvalAuto'] ?? '',
      preclienteAvaliacao: json['preclienteAvaliacao'] ?? '',
      preclienteJson: json['preclienteJson'] ?? '',
      preclienteDataVisita: json['preclienteDataVisita'] != null
          ? DateTime.tryParse(json['preclienteDataVisita'])
          : null,
      preclienteCondominio: json['preclienteCondominio'],
      consultor: json['Consultor'] ?? 0,
    );
  }
}
