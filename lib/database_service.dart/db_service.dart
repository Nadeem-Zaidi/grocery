import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/database_service.dart/IDBService.dart';
import 'package:grocery_app/database_service.dart/model_registry.dart';

class DBService<T> implements IDBService<T> {
  FirebaseFirestore fireStore;
  String collectionPath;
  DBService({required this.fireStore, required this.collectionPath});
  @override
  Future<T?> create(T data) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> dispose() {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  @override
  Future<(List<T>, DocumentSnapshot<Object?>?)> getAll(
      int limit, String orderBy,
      [DocumentSnapshot<Object?>? lastDocument,
      bool descending = false]) async {
    try {
      CollectionReference collectionReference =
          fireStore.collection(collectionPath);
      Query query = collectionReference
          .orderBy(orderBy, descending: descending)
          .limit(limit);
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }
      QuerySnapshot querySnapshot =
          await query.get().timeout(Duration(seconds: 5));

      if (querySnapshot.docs.isEmpty) {
        return (<T>[], null);
      }
      final documents = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ModelRegistry.fromMap<T>(data);
      }).toList();
      return (documents, querySnapshot.docs.last);
    } catch (e) {
      print('Error in getAll DBService: $e');
      rethrow;
    }
  }

  @override
  Future<T?> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  void startStream(
      {int limit = 10,
      DocumentSnapshot<Object?>? lastDocument,
      String orderByField = 'name',
      bool descending = false}) {
    // TODO: implement startStream
  }

  @override
  void stopStream() {
    // TODO: implement stopStream
  }

  @override
  Future<T?> update(Map<String, dynamic> data) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<(List<T>, DocumentSnapshot<Object?>?, bool)> whereClause(
      Query<Object?> Function(CollectionReference<Object?> p1) queryBuilder,
      [DocumentSnapshot<Object?>? lastDocument]) {
    // TODO: implement whereClause
    throw UnimplementedError();
  }
}
