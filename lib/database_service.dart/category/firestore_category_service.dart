import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/database_service.dart/idatabase_service.dart';

import '../../models/category.dart';

class FirestoreCategoryService implements IdatabaseService<Category> {
  FirebaseFirestore firestore;
  String collectionName;
  FirestoreCategoryService(
      {required this.firestore, required this.collectionName});

  @override
  Future<(List<Category>, DocumentSnapshot?)> getAll(int limit,
      [DocumentSnapshot? lastDocument]) async {
    try {
      Query query = firestore
          .collection(collectionName)
          .orderBy('name', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      QuerySnapshot querySnapshot =
          await query.get().timeout(Duration(seconds: 5));

      if (querySnapshot.docs.isEmpty) {
        return (<Category>[], null);
      }

      // Convert documents to Categories
      final documents = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        return Category.fromMap({...data, 'id': doc.id});
      }).toList();

      // Return with the actual last document
      return (documents, querySnapshot.docs.last);
    } catch (e) {
      print('Error in getAll: $e');
      rethrow;
    }
  }

  @override
  Future<Category?> getById(String id) async {
    try {
      DocumentReference docRef = firestore.collection(collectionName).doc(id);
      DocumentSnapshot docSnapShot = await docRef.get();

      if (!docSnapShot.exists) {
        return null;
      }
      Map<String, dynamic> doc = docSnapShot.data() as Map<String, dynamic>;
      doc["id"] = docSnapShot.id;

      return Category.fromMap(doc);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Category?> create(Category category) async {
    try {
      Map<String, dynamic> categoryMap = category.toJson();
      categoryMap.removeWhere(
          (key, value) => (key == "id" || value == "" || value == null));

      // Validate required fields
      final requiredFields = ['name', 'path', 'url'];
      for (final field in requiredFields) {
        if (categoryMap[field] == null) {
          throw ArgumentError('Error: $field cannot be null');
        }
      }

      final name = categoryMap['name'] as String?;
      if (name == null || name.isEmpty) {
        throw ArgumentError('Error: "name" cannot be null or empty');
      }

      String newPath = name;
      final parent = categoryMap['parent'] as String? ?? '';

      final newCategoryRef = firestore.collection(collectionName).doc();
      if (parent.isNotEmpty) {
        final parentDoc =
            await firestore.collection(collectionName).doc(parent).get();
        if (parentDoc.exists) {
          final parentPath = parentDoc['path'] as String? ?? '';
          newPath = "$parentPath/$name";
        } else {
          throw ArgumentError(
              'Error: Specified parent category does not exist');
        }
      }

      // Prepare complete data
      final categoryData = {
        "id": newCategoryRef.id,
        "name": name,
        "parent": parent,
        "path": newPath,
        "url": categoryMap['url'],
      };

      try {
        await newCategoryRef.set(categoryData);
        return Category.fromMap(categoryData);
      } catch (e) {
        print("Error creating category: $e");
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Category?> update(Map<String, dynamic> data) async {
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
  Future<(List<Category>, DocumentSnapshot?, bool)> whereClause(
      Query Function(CollectionReference) queryBuilder,
      [DocumentSnapshot? lastDocument]) async {
    List<Category> categories = [];

    try {
      Query query = queryBuilder(firestore.collection(collectionName));

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      QuerySnapshot qs = await query.get().timeout(Duration(seconds: 5));
      if (qs.docs.isEmpty) {
        return (<Category>[], null, true);
      }

      categories = qs.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        return Category.fromMap({...data, "id": doc.id});
      }).toList();

      return (categories, lastDocument, false);
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
