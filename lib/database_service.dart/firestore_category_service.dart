import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/database_service.dart/idatabase_service.dart';

import '../categories/models/category.dart';

class FirestoreCategoryService implements IdatabaseService {
  FirebaseFirestore firestore;
  String collectionName;
  FirestoreCategoryService(
      {required this.firestore, required this.collectionName});
  @override
  Future<(List<Category>, DocumentSnapshot?)> getAll(int limit,
      [DocumentSnapshot? lastDocument]) async {
    List<Category> documents = [];
    CollectionReference collectionReference =
        firestore.collection(collectionName);

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
          return Category.fromMap(docData);
        }).toList();

        DocumentSnapshot? lastDocument =
            querySnapshot.docs.last; // Track last doc
        return (documents, lastDocument);
      }
    } catch (e) {
      rethrow;
    }

    return (documents, null);
  }

  @override
  Future getById(String id) async {
    DocumentReference docRef = firestore.collection(collectionName).doc(id);
    DocumentSnapshot docSnapShot = await docRef.get();
    if (docSnapShot.exists) {
      return Category.fromMap(docSnapShot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  @override
  Future create(Map<String, dynamic> data) async {
    List<String> requiredField = ['name', 'parent', 'path', 'url'];
    Set<String> allowedFields = requiredField.toSet();
    //checking for extra fields
    Set<String> extraKeys = data.keys.toSet().difference(allowedFields);
    if (extraKeys.isNotEmpty) {
      throw ArgumentError(
          'Error : Unexpected fields found:${extraKeys.join(",")}');
    }
    //checking for the misssing

    String? missingKey =
        requiredField.firstWhere((key) => data[key] == null, orElse: () => '');

    if (missingKey.isNotEmpty) {
      throw ArgumentError('Error :$missingKey can not be null');
    }

    Category category = Category(
      id: data['id'],
      name: data["name"],
      parent: data["parent"],
      path: data["path"],
      url: data["url"],
    );

    DocumentReference docRef =
        await firestore.collection(collectionName).add(category.toJson());

    return docRef;
  }
}
