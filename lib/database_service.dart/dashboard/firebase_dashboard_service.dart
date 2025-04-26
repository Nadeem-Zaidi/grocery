import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/models/category.dart';
import 'package:grocery_app/models/sections/dashboared_element.dart';

import '../../models/sections/section.dart';

class FirebaseDashBoard {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseDashBoard(this.firestore);

  Future<List<Section>> getAll() async {
    List<Section> result = [];
    var data = await firestore
        .collection("sections")
        .orderBy('sequence')
        .get(); //here i am getting each sections in the dashboared
    //looping through each section in a dashboared

    for (var section in data.docs) {
      //getting name of the section
      print(section.data());

      String name = section.data()["name"];
      String type = section.data()["type"];
      String sequence = section.data()["sequence"];
      //getting all the name of the elements with ids
      List<String> elementIds = List<String>.from(section.data()["elements"]);

      if (type == "category") {
        late Section<Category> sec;
        List<DocumentSnapshot<Map<String, dynamic>>> elements =
            await Future.wait(elementIds
                .map((id) => firestore.collection("categories").doc(id).get()));
        late List<Category> categories = [];
        for (var i in elements) {
          categories.add(Category.fromMap(i.data() as Map<String, dynamic>));
        }

        sec = Section.fromMap({
          "name": name,
          "type": type,
          "sequence": int.parse(sequence),
          "elements": categories as List<dynamic>
        });

        result.add(sec);
      }
    }

    return result;
  }
}
