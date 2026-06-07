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

  static String getLocalById(String id) => '/api/v1/locais/id?id=$id';
  static String getLocalByNome(String nome) => '/api/v1/locais/nome?nome=$nome';

  static String localById(String id) => '/api/v1/locais?id=$id';

  static String vacinaByLocalId(String id) => '/api/v1/vacinas/locais?id=$id';
  static String vacinaByLocal(String local) =>
      '/api/v1/vacinas/local?local=$local';

  static String vacinaByLocalName(String name) =>
      '/api/v1/vacinas/locais/name$name';

  static String vacinaById(String id) => '/api/v1/vacinas?id=$id';

  static String vacinaByName(String name) => '/api/v1/vacinas/$name';

  static String getCep(String cep) => '/api/cep/v1/$cep';
}
