import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/database_service.dart/idatabase_service.dart';
import 'package:grocery_app/models/inventory/inventory.dart';

class FirestoreInventoryService implements IdatabaseService<Inventory> {
  final FirebaseFirestore fireStore;
  final String collectionName;
  FirestoreInventoryService(
      {required this.fireStore, required this.collectionName});
  @override
  Future<Inventory?> create(Inventory data) async {
    Map<String, dynamic> inventoryMap = data.toMap();
    inventoryMap.removeWhere(
        (key, value) => (key == "id" || value == "" || value == null));
    if (inventoryMap.isEmpty) {
      throw Exception("Valid form data is required");
    }

    try {
      DocumentReference inventoryReference =
          fireStore.collection(collectionName).doc();
      Map<String, dynamic> inventoryData = {
        "id": inventoryReference.id,
        ...inventoryMap
      };
      await inventoryReference.set(inventoryMap);
      return Inventory.fromMap(inventoryData);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<(List<Inventory>, DocumentSnapshot<Object?>?)> getAll(int limit,
      [DocumentSnapshot<Object?>? lastDocument]) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<Inventory?> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<Inventory?> update(Map<String, dynamic> data) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<(List<Inventory>, DocumentSnapshot?, bool)> whereClause(
      Query<Object?> Function(CollectionReference<Object?> p1) queryBuilder,
      [DocumentSnapshot? lastDocument]) {
    // TODO: implement whereClause
    throw UnimplementedError();
  }

  @override
  Future<void> dispose() {
    // TODO: implement dispose
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
}
