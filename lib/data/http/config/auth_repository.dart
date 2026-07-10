import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vacina_app/data/http/api_endpoints.dart';
import 'package:vacina_app/util/app_logger.dart';

class AuthRepository {
  // Substitua pela classe real de endpoints do seu projeto se for diferente
  final String baseUrl = ApiEndpoints.baseUrl;

  /// PASSO 1: Envia o e-mail para a API disparar o código de 6 dígitos
  Future<bool> solicitarCodigoRecuperacao(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiEndpoints.forgot}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      // Retorna true se a API aceitou o e-mail (Status 200 ou 204)
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e, stackTrace) {
      AppLogger.log(
        "Erro na rota forgot-password",
        error: e,
        stackTrace: stackTrace,
        name: 'AuthRepository',
      );
      return false;
    }
  }

  /// PASSO 2: Envia o código que o usuário recebeu por e-mail junto com a nova senha escolhida
  Future<bool> redefinirSenha(
    String email,
    String codigo,
    String novaSenha,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiEndpoints.reset}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'code': codigo,
          'password': novaSenha,
        }),
      );

      // Retorna true se a senha foi alterada com sucesso no backend
      return response.statusCode == 200;
    } catch (e, stackTrace) {
      AppLogger.log(
        "Erro na rota reset-password",
        error: e,
        stackTrace: stackTrace,
        name: 'AuthRepository',
      );
      return false;
    }
  }
}
