import 'package:vacina_app/data/models/local_model.dart';

abstract class ILocalRepository {
  Future<List<LocalModel>>getLocal();
}

class LocalRepository implements ILocalRepository {
  @override
  Future<List<LocalModel>> getLocal() {
    // TODO: implement getLocal
    throw UnimplementedError();
  }

}