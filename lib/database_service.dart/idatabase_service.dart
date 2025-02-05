abstract class IdatabaseService {
  Future<List<dynamic>> getAll();
  Future<dynamic> getById(String id);
  Future<dynamic> create(Map<String, dynamic> data);
}
