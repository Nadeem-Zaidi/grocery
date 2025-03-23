import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category.dart';

abstract class IdatabaseService {
  Future<(List<Category>, DocumentSnapshot?)> getAll(int limit,
      [DocumentSnapshot? lastDocument]);
  Future<dynamic> getById(String id);
  Future<dynamic> create(String name, String? parent, String url);
  Future<dynamic> update(Map<String, dynamic> data);
  Future<List<Category>> whereClause(
      Query Function(CollectionReference) queryBuilder);
}
