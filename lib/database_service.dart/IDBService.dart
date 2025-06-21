import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IDBService<T> {
  Future<(List<T>, DocumentSnapshot?)> getAll(int limit, String orderBy,
      [DocumentSnapshot? lastDocument, bool descending = false]);
  Future<T?> getById(String id);
  Future<T?> create(T data);
  Future<T?> update(Map<String, dynamic> data);
  Future<(List<T>, DocumentSnapshot?, bool)> whereClause(
      Query Function(CollectionReference) queryBuilder,
      [DocumentSnapshot? lastDocument]);
  void startStream({
    int limit = 10,
    DocumentSnapshot? lastDocument,
    String orderByField = 'name',
    bool descending = false,
  });
  void stopStream();

  // Optional: For resource cleanup
  Future<void> dispose();
}
