import 'package:cloud_firestore/cloud_firestore.dart';

import '../categories/models/category.dart';

abstract class IdatabaseService {
  Future<(List<Category>, DocumentSnapshot?)> getAll(int limit,
      [DocumentSnapshot? lastDocument]);
  Future<dynamic> getById(String id);
  Future<dynamic> create(Map<String, dynamic> data);
}
