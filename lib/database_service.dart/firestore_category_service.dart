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
    CollectionReference collectionReference =
        firestore.collection(collectionName);
    QuerySnapshot querySnapshot = await collectionReference.get();
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
  Future create(Map<String, dynamic> data) {
    // TODO: implement create
    throw UnimplementedError();
  }
}
