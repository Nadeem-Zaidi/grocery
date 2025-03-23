import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/product/product.dart';

class FirestoreProductService {
  FirebaseFirestore fireStore;
  String collectionName;
  FirestoreProductService(
      {required this.fireStore, required this.collectionName});
  Future<String> create(Product product) async {
    Map<String, dynamic> productMap = product.toMap();
    productMap.removeWhere(
        (key, value) => (key == "id" || value == "" || value == null));

    if (productMap.isEmpty) {
      throw Exception("Valid Form data is required");
    }

    try {
      CollectionReference productCollection =
          fireStore.collection(collectionName);
      DocumentReference productDocument =
          await productCollection.add(productMap);
      return productDocument.id;
    } catch (e) {
      throw Exception("Product creation failed");
    }
  }

  Future<(List<Product>, DocumentSnapshot?)> fetchProducts(int limit,
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
}
