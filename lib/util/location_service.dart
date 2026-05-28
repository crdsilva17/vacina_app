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
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }
}
