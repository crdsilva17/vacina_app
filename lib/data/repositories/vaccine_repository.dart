import 'package:vacina_app/data/dto/vaccine_request.dart';
import 'package:vacina_app/data/models/vaccine_model.dart';

abstract class IVaccineRepository {
  Future<List<VaccineModel>> getVaccines();
  Future<void> postVaccine(VaccineRequest vaccine);
  Future<void> deleteVaccine(String id);
  Future<void> putVaccine(String id);
}
