import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    // Verifica se GPS está ativado
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('Serviço de localização desativado.');
    }

    // Verifica permissão
    LocationPermission permission = await Geolocator.checkPermission();

    // Solicita permissão caso necessário
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Permissão negada
    if (permission == LocationPermission.denied) {
      throw Exception('Permissão de localização negada.');
    }

    // Permissão negada permanentemente
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Permissão negada permanentemente. '
        'Habilite manualmente nas configurações.',
      );
    }

    // Obtém posição atual
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(
            seconds: 10,
          ), // Evita travar o app se o GPS demorar
        ),
      );
    } catch (e) {
      // Backup: busca a última posição conhecida se o GPS falhar por timeout
      final lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null) return lastPosition;
      rethrow;
    }
  }
}
