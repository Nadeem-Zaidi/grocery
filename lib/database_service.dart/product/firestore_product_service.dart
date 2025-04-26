import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/database_service.dart/idatabase_service.dart';

import '../../models/product/product.dart';

class FirestoreProductService implements IdatabaseService<Product> {
  FirebaseFirestore fireStore;
  String collectionName;
  FirestoreProductService(
      {required this.fireStore, required this.collectionName});

  //method to create the product record
  @override
  Future<Product?> create(Product product) async {
    Map<String, dynamic> productMap = product.toMap();
    productMap.removeWhere(
        (key, value) => (key == "id" || value == "" || value == null));

    if (productMap.isEmpty) {
      throw Exception("Valid Form data is required");
    }

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
      return Product.fromMap(data);
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
  Future<(List<Product>, DocumentSnapshot?)> whereClause(
      Query<Object?> Function(CollectionReference<Object?> p1) queryBuilder,
      [DocumentSnapshot? lastDocument]) async {
    List<Product> products = [];
    try {
      Query query = queryBuilder(fireStore.collection(collectionName));
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }
      QuerySnapshot qs =
          await query.orderBy("name").get().timeout(Duration(seconds: 5));
      if (qs.docs.isEmpty) {
        return (<Product>[], lastDocument);
      }
      products = qs.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Product.fromMap({...data, "id": doc.id});
      }).toList();

      return (products, lastDocument);
    } catch (e) {
      rethrow;
    }
  }
}
