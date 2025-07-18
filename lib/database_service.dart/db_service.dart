import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/database_service.dart/IDBService.dart';
import 'package:grocery_app/database_service.dart/ientity.dart';
import 'package:grocery_app/database_service.dart/model_registry.dart';

class DBService<T extends IEntity> implements IDBService<T> {
  FirebaseFirestore fireStore;
  String collectionPath;
  DBService({required this.fireStore, required this.collectionPath});
  @override
  Future<T> create(T data) async {
    try {
      Map<String, dynamic> dataToMap = data.toMap();

      if (dataToMap.isEmpty) {
        throw Exception("No data to create product");
      }
      DocumentReference docRef = fireStore.collection(collectionPath).doc();
      Map<String, dynamic> dataToMapWithId = {"id": docRef.id, ...dataToMap};
      await docRef.set(dataToMap);
      return ModelRegistry.fromMap<T>(dataToMapWithId);
    } catch (error) {
      print(error);
      rethrow;
    }
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
      List<T> documents = [];

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
      documents = querySnapshot.docs.map((doc) {
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
  Future<T?> getById(String id) async {
    try {
      DocumentReference docRef = fireStore.collection(collectionPath).doc(id);
      DocumentSnapshot docSnapShot = await docRef.get();
      if (!docSnapShot.exists || docSnapShot.data() == null) {
        return null;
      }

      final data = docSnapShot.data() as Map<String, dynamic>;

      return ModelRegistry.fromMap<T>({"id": docSnapShot.id, ...data});
    } catch (error) {
      print("error in getById in productt=>$error");
      rethrow;
    }
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
      [DocumentSnapshot<Object?>? lastDocument]) async {
    List<T> items = [];
    try {
      Query query = queryBuilder(fireStore.collection(collectionPath));
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }
      QuerySnapshot qs = await query.get().timeout(Duration(seconds: 5));
      if (qs.docs.isEmpty) {
        return (<T>[], lastDocument, true);
      }
      items = qs.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return ModelRegistry.fromMap<T>({"id": doc.id, ...data});
      }).toList();

      return (items, qs.docs.last, false);
    } catch (error, stacktrace) {
      print("error in db service");
      print(error);
      print(stacktrace);
      print("error in db service");
      rethrow;
    }
  }

  @override
  FirebaseFirestore getFireStore() {
    return fireStore;
  }
}
