import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IdatabaseService<T> {
  Future<(List<T>, DocumentSnapshot?)> getAll(int limit,
      [DocumentSnapshot? lastDocument]);
  Future<T?> getById(String id);
  Future<T?> create(T data);
  Future<T?> update(Map<String, dynamic> data);
  Future<(List<T>, DocumentSnapshot?)> whereClause(
      Query Function(CollectionReference) queryBuilder,
      [DocumentSnapshot? lastDocument]);
}
