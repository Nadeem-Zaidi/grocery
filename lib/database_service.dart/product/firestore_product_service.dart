import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/database_service.dart/idatabase_service.dart';

import '../../models/product/product.dart';

class FirestoreProductService implements IdatabaseService<Product> {
  FirebaseFirestore fireStore;
  String collectionName;
  FirestoreProductService(
      {required this.fireStore, required this.collectionName});
  final StreamController<(List<Product>, DocumentSnapshot?)>
      _productStreamController =
      StreamController<(List<Product>, DocumentSnapshot?)>.broadcast();
  StreamSubscription<QuerySnapshot>? _productsSubscription;

  Stream<(List<Product>, DocumentSnapshot?)> get productsStream =>
      _productStreamController.stream;

  //method to create the product record
  @override
  Future<Product?> create(Product product) async {
    //convert the incoming product to map
    Map<String, dynamic> productMap = product.toMap();
    productMap.removeWhere(
        (key, value) => (key == "id" || value == "" || value == null));

    if (productMap.isEmpty) {
      throw Exception("Valid Form data is required");
    }

    /*** Add the logic here for the mandatory fields,remove the case of getting null in the ui */
    List<String> mandatoryFields = ["url", "name", "description", ""];

    try {
      DocumentReference productRef = fireStore.collection(collectionName).doc();
      Map<String, dynamic> productData = {"id": productRef.id, ...productMap};
      await productRef.set(productMap);
      return Product.fromMap(productData);
    } catch (e) {
      print("Error occured while creating a product");
      rethrow;
    }
  }

  @override
  Future<(List<Product>, DocumentSnapshot?)> getAll(int limit,
      [DocumentSnapshot? lastDocument]) async {
    List<Product> documents = [];
    CollectionReference collectionReference =
        fireStore.collection(collectionName);

    try {
      Query query = collectionReference
          .orderBy('name', descending: true) // Order by timestamp
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      QuerySnapshot querySnapshot =
          await query.get().timeout(Duration(seconds: 5));

      if (querySnapshot.docs.isNotEmpty) {
        documents = querySnapshot.docs.map((doc) {
          Map<String, dynamic> docData = {
            ...(doc.data() != null
                ? doc.data() as Map<String, dynamic>
                : {}), // Handle null case
            "id": doc.id,
          };
          return Product.fromMap(docData);
        }).toList();

        DocumentSnapshot? lastDocument = querySnapshot.docs.last;
        return (documents, lastDocument);
      }
    } catch (e) {
      rethrow;
    }

    return (documents, null);
  }

  @override
  Future<Product?> getById(String id) async {
    try {
      DocumentReference productDocument =
          fireStore.collection(collectionName).doc(id);
      DocumentSnapshot productSnapshot = await productDocument.get();

      if (!productSnapshot.exists || productSnapshot.data() == null) {
        return null; // No product found
      }

      final data = productSnapshot.data() as Map<String, dynamic>;
      print({...data, id: productSnapshot.id});
      return Product.fromMap({...data, "id": productSnapshot.id});
    } catch (e) {
      print("Error fetching product by ID: $e"); // Log the error
      throw Exception(
          "Failed to fetch product: $e"); // Throw a meaningful exception
    }
  }

  @override
  Future<Product?> update(Map<String, dynamic> data) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<(List<Product>, DocumentSnapshot?, bool)> whereClause(
      Query<Object?> Function(CollectionReference<Object?> p1) queryBuilder,
      [DocumentSnapshot? lastDocument]) async {
    List<Product> products = [];
    try {
      Query query = queryBuilder(fireStore.collection(collectionName));
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }
      QuerySnapshot qs = await query.get().timeout(Duration(seconds: 5));
      if (qs.docs.isEmpty) {
        return (<Product>[], lastDocument, true);
      }
      products = qs.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Product.fromMap({...data, "id": doc.id});
      }).toList();

      return (products, qs.docs.last, false);
    } catch (e) {
      rethrow;
    }
  }

  @override
  void startStream(
      {int limit = 4,
      DocumentSnapshot<Object?>? lastDocument,
      String orderByField = 'name',
      bool descending = false}) {
    _productsSubscription?.cancel();

    Query query =
        fireStore.collection(collectionName).orderBy(orderByField).limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    _productsSubscription = query.snapshots().listen((snapShot) {
      final products = snapShot.docs.map((doc) {
        return Product.fromMap(
            {...doc.data() as Map<String, dynamic>, "id": doc.id});
      }).toList();
      final newLastDocument =
          snapShot.docs.isNotEmpty ? snapShot.docs.last : null;

      if (!_productStreamController.isClosed) {
        _productStreamController.add((products, newLastDocument));
      }
    }, onError: (error) {
      if (!_productStreamController.isClosed) {
        _productStreamController.addError(error);
      }
    });
  }

  @override
  void stopStream() {
    _productsSubscription?.cancel();
  }

  @override
  Future<void> dispose() async {
    await _productStreamController.close();
    stopStream();
  }
}
