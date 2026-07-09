import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class AppLogger {
  // Função que substitui o developer.log
  static void log(
    String message, {
    String name = 'app',
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Só executa o log se o app NÃO estiver em produção (Release)
    if (kDebugMode) {
      developer.log(message, name: name, error: error, stackTrace: stackTrace);
    }
  }
}
