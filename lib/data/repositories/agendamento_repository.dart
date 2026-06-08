import 'dart:convert';
import 'package:http/http.dart' as http;

class AgendamentoRepository {
  final String baseUrl;

  AgendamentoRepository({required this.baseUrl});

  Future<List<String>> getHorariosDisponiveis(
    String localId,
    DateTime data,
    String token,
  ) async {
    final url = Uri.parse(
      '$baseUrl/api/v1/agendamentos/horarios'
      '?localId=$localId'
      '&data=${data.toIso8601String().split('T')[0]}',
    );

    final response = await http.get(url, headers: {'Authorization': token});

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar horários');
    }

    return List<String>.from(jsonDecode(response.body));
  }

  Future<void> agendar(
    String vacinaId,
    String localId,
    DateTime data,
    String horario,
    String token,
  ) async {
    final url = Uri.parse('$baseUrl/api/v1/agendamentos');

    final body = {
      'vacinaId': vacinaId,
      'localId': localId,
      'data': data.toIso8601String().split('T')[0],
      'horario': horario,
    };

    final response = await http.post(
      url,
      headers: {'Authorization': token, 'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao realizar agendamento');
    }
  }

  Future<void> cancelar(String vacinaId, String token) async {
    final url = Uri.parse('$baseUrl/api/v1/agendamentos/cancelar/$vacinaId');

    final response = await http.put(url, headers: {'Authorization': token});

    if (response.statusCode != 200) {
      throw Exception('Erro ao cancelar agendamento');
    }
  }

  Future<bool> isScheduled(String vacinaId, String token) async {
    final url = Uri.parse(
      '$baseUrl/api/v1/agendamentos/vacina/$vacinaId/agendado',
    );

    final response = await http.get(url, headers: {'Authorization': token});

    if (response.statusCode != 200) {
      throw Exception('Erro ao verificar agendamento');
    }

    return jsonDecode(response.body);
  }
}
