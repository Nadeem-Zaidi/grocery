import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/database_service.dart/idatabase_service.dart';

import '../categories/category.dart';

class FirestoreCategoryService implements IdatabaseService {
  FirebaseFirestore firestore;
  String collectionName;
  FirestoreCategoryService(
      {required this.firestore, required this.collectionName});
  @override
  Future<List> getAll() async {
    final completer = Completer<List<Category>>();
    CollectionReference collectionReference =
        firestore.collection(collectionName);
    QuerySnapshot querySnapshot =
        await collectionReference.get().timeout(Duration(seconds: 5));
    List<Category> documents = querySnapshot.docs.map((doc) {
      return Category.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
    return documents;
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
    List<String> requiredField = ['id', 'name', 'parent', 'path'];
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
        path: data["path"]);

    DocumentReference docRef =
        await firestore.collection(collectionName).add(category.toJson());

    return docRef;
  }
}
