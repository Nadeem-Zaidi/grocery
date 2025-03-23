import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/database_service.dart/idatabase_service.dart';

import '../../models/category.dart';

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

        DocumentSnapshot? lastDocument = querySnapshot.docs.last;
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
      Map<String, dynamic> doc = docSnapShot.data() as Map<String, dynamic>;
      doc["id"] = docSnapShot.id;

      return Category.fromMap(doc);
    } else {
      return null;
    }
  }

  @override
  Future create(String name, String? parent, String url) async {
    // List<String> requiredField = ['name', 'path', 'parent' 'url'];
    // Set<String> allowedFields = requiredField.toSet();
    // //checking for extra fields
    // Set<String> extraKeys = data.keys.toSet().difference(allowedFields);
    // if (extraKeys.isNotEmpty) {
    //   throw ArgumentError(
    //       'Error : Unexpected fields found:${extraKeys.join(",")}');
    // }

    // String? missingKey =
    //     requiredField.firstWhere((key) => data[key] == null, orElse: () => '');

    // if (missingKey.isNotEmpty) {
    //   throw ArgumentError('Error :$missingKey can not be null');
    // }

    if (name.isEmpty) {
      throw ArgumentError('Error :"name" can not be null');
    }

    DocumentReference newCategoryRef =
        firestore.collection(collectionName).doc();

    String newPath = name;

    if (parent != null || parent.toString().isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> parentDoc =
          await firestore.collection(collectionName).doc(parent).get();
      if (parentDoc.exists) {
        String parentPath = parentDoc['path'];
        newPath = "$parentPath/$name";
      }
    }

    Map<String, dynamic> categoryData = {
      "id": newCategoryRef.id,
      "name": name,
      "parent": parent,
      "path": newPath,
      "url": url
    };

    try {
      await newCategoryRef.set(categoryData);
    } catch (e) {
      print("Error creating category: $e");
      rethrow;
    }

    return categoryData;
  }

  @override
  Future update(Map<String, dynamic> data) async {
    print(data);
    List<String> allowedFields = ["id", 'name', 'parent', 'path', 'url'];
    List<String> dataFields = data.keys.toList();
    List<String> invalidFields = dataFields
        .where((attribute) => !allowedFields.contains(attribute))
        .toList();

    if (invalidFields.isNotEmpty) {
      throw ArgumentError("Error: Please provide valid attribute to update");
    }

    if (data.containsKey("id") &&
        (data["id"] == null || data["id"].toString().trim().isEmpty)) {
      throw ArgumentError('Error: Invalid Id');
    }
    String id = data["id"];
    print("id from update");
    print(id);
    print("id from update");

    Map<String, dynamic> refinedData = data
      ..removeWhere((key, value) => value == null || value == "");

    refinedData.remove('id');

    await firestore.collection(collectionName).doc(id).update(refinedData);
    DocumentSnapshot documentSnap =
        await firestore.collection(collectionName).doc(id).get();
    if (documentSnap.exists) {
      return Category.fromMap(documentSnap.data() as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Future<List<Category>> whereClause(
      Query Function(CollectionReference) queryBuilder) async {
    List<Category> documents = [];

    try {
      Query query = queryBuilder(firestore.collection(collectionName));
      QuerySnapshot querySnapshot = await query.get();
      print(querySnapshot.docs);

      documents = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        return Category.fromMap({...data, "id": doc.id});
      }).toList();
    } on FirebaseException catch (e) {
      print("Firestore error: ${e.message}");
      rethrow;
    } on TimeoutException catch (e) {
      print("Query timed out: ${e.message}");
      rethrow;
    } catch (e) {
      print("Unexpected error: $e");
      rethrow;
    }

    return documents;
  }
}
