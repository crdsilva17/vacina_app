class ApiEndpoints {
  static final String baseUrl = 'https://vacinas-api-production.up.railway.app';
  /*
  static final String baseUrl = kIsWeb
      ? 'http://localhost:8080'
      : 'http://10.0.2.2:8080';
  //: 'http://192.168.18.123:8080';
  */

  static const String baseCep = 'https://brasilapi.com.br';

  static const String locais = '/api/v1/locais';
  static const String login = '/api/v1/auth/login';
  static const String register = '/api/v1/auth/register';
  static const String user = '/api/v1/usuarios';
  static const String vacinas = '/api/v1/vacinas';
  static const String registerToken = '/api/v1/device-token';
  static const String change = '/api/v1/usuarios/change-password';
  static const String notifications = '/api/v1/notifications';
  static const String count = '/api/v1/notifications/count';
  static const String campanha = '/api/v1/campanha';
  static const String agendamentos = '/api/v1/agendamentos';
  static const String uriCep = '/api/cep/v1';
  static const String openMap =
      'https://openstreetmap.org{position.latitude}&lon=';

  static String setNotificationRead(String id) => '$notifications/$id/read';
  static String getLocalById(String id) => '$locais/id?id=$id';
  static String getLocalByNome(String nome) => '$locais/nome?nome=$nome';

  static String localById(String id) => '$locais?id=$id';

  static String vacinaById(String id) => '$vacinas/$id';

  static String vacinaByName(String name) => '$vacinas/$name';

  static String campanhaById(String id) => '$campanha/$id';

  static String isSchedule(String vacinaId) =>
      '$agendamentos/vacina/$vacinaId/agendado';

  static String getHorarios(String localId, DateTime data) =>
      '$agendamentos/horarios'
      '?localId=$localId'
      '&data=${data.toIso8601String().split('T')[0]}';

  static String cancelAgendamento(String vacinaId) =>
      '$agendamentos/cancelar/$vacinaId';

  static String getAgendamentos(String userId) => '$agendamentos/$userId';

  static String campanhaByLocalId(String localId) => '$campanha/$localId';

  static String getCep(String cep) => '$uriCep/$cep';

  static String openStreetMap(double position) => '$openMap$position';
}
