import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDashBoard {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseDashBoard(this.firestore);

  Future<List<Map<String, dynamic>>> getAll() async {
    List<Map<String, dynamic>> result = [];
    QuerySnapshot<Map<String, dynamic>> data =
        await firestore.collection("sections").get();

    for (var section in data.docs) {
      Map<String, dynamic> sec = {};
      String name = section.data()["name"];

      List<String> elementIds = List<String>.from(section.data()["elements"]);

      // Fetching all the documents in parallel
      List<DocumentSnapshot<Map<String, dynamic>>> categoryDocs =
          await Future.wait(elementIds
              .map((id) => firestore.collection("categories").doc(id).get()));

      // Initialize sec[name] as a list and add category data
      sec[name] = [];
      for (var categoryDoc in categoryDocs) {
        if (categoryDoc.exists) {
          sec[name].add(categoryDoc.data());
        }
      }

      result.add(sec);
    }

    return result;
  }
}
