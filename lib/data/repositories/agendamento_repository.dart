import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vacina_app/data/http/api_endpoints.dart';
import 'package:vacina_app/data/models/agendamento_model.dart';

class AgendamentoRepository {
  final String baseUrl;

  AgendamentoRepository({required this.baseUrl});

  Future<List<String>> getHorariosDisponiveis(
    String localId,
    DateTime data,
    String token,
  ) async {
    final url = Uri.parse('$baseUrl${ApiEndpoints.getHorarios(localId, data)}');

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
    final url = Uri.parse('$baseUrl${ApiEndpoints.agendamentos}');

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
    final url = Uri.parse(
      '$baseUrl${ApiEndpoints.cancelAgendamento(vacinaId)}',
    );

    final response = await http.put(url, headers: {'Authorization': token});

    if (response.statusCode != 200) {
      throw Exception('Erro ao cancelar agendamento');
    }
  }

  Future<bool> isScheduled(String vacinaId, String token) async {
    final url = Uri.parse('$baseUrl${ApiEndpoints.isSchedule(vacinaId)}');

    final response = await http.get(url, headers: {'Authorization': token});

    if (response.statusCode != 200) {
      throw Exception('Erro ao verificar agendamento');
    }

    return jsonDecode(response.body);
  }

  Future<List<AgendamentoModel>> getAgendamentos(
    String userId,
    String token,
  ) async {
    final url = Uri.parse('$baseUrl${ApiEndpoints.getAgendamentos(userId)}');

    final response = await http.get(url, headers: {'Authorization': token});

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar agendamentos');
    }

    List<AgendamentoModel> agendamentos = [];
    final body = jsonDecode(response.body);
    body.map((agendamento) {
      AgendamentoModel agendamentoModel = AgendamentoModel.fromJson(
        agendamento,
      );
      agendamentos.add(agendamentoModel);
    }).toList();

    return agendamentos;
  }
}
