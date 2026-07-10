class AgendamentoModel {
  final String id;
  final String usuarioId;
  final String vacinaId;
  final String localId;
  final String data;
  final String horario;

  AgendamentoModel({
    required this.id,
    required this.usuarioId,
    required this.vacinaId,
    required this.localId,
    required this.data,
    required this.horario,
  });

  factory AgendamentoModel.fromJson(Map<String, dynamic> json) {
    return AgendamentoModel(
      id: json["id"],
      usuarioId: json["usuarioId"],
      vacinaId: json["vacinaId"],
      localId: json["localId"],
      data: json["data"],
      horario: json["horario"],
    );
  }
}
