import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/database_service.dart/idatabase_service.dart';
import 'package:grocery_app/models/category.dart';

import '../../models/sections/section.dart';

class FirebaseDashBoard implements IdatabaseService<Section> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseDashBoard(this.firestore);
  @override
  Future<(List<Section>, DocumentSnapshot?)> getAll(int limit,
      [DocumentSnapshot? lastDocument]) async {
    final List<Section> result = []; // Properly initialized here
    try {
      Query query =
          firestore.collection('sections').orderBy('sequence').limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final QuerySnapshot querySnapshot =
          await query.get().timeout(const Duration(seconds: 5));

      if (querySnapshot.docs.isEmpty) {
        return (result, null); // Now properly returning the initialized list
      }

      final List<Future<void>> processingFutures = [];

      for (final sectionDoc in querySnapshot.docs) {
        processingFutures.add(_processSectionDocument(sectionDoc, result));
      }

      await Future.wait(processingFutures);

      return (result, querySnapshot.docs.last);
    } on TimeoutException {
      throw TimeoutException('Section data fetch timed out');
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch sections: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> _processSectionDocument(
    DocumentSnapshot sectionDoc,
    List<Section> result,
  ) async {
    try {
      final sectionData = sectionDoc.data() as Map<String, dynamic>;

      final String name = sectionData['name'] as String;
      final String type = sectionData['type'] as String;
      final int sequence = int.parse(sectionData['sequence']);
      final List<String> elementIds =
          List<String>.from(sectionData['elements']);

      // Fetch all categories in parallel
      final List<DocumentSnapshot> categoryDocs = await Future.wait(
        elementIds
            .map((id) => firestore.collection('categories').doc(id).get()),
      );

      final List<Category> categories = categoryDocs
          .where((doc) => doc.exists) // Filter out non-existent documents
          .map((doc) => Category.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      final section = Section.fromMap({
        'name': name,
        'type': type,
        'sequence': sequence,
        'elements': categories,
      });

      result.add(section);
    } catch (e) {
      // Log the error but continue processing other sections
      rethrow;
    }
  }

  @override
  Future<Section?> create(Section data) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Section?> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<Section?> update(Map<String, dynamic> data) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<(List<Section>, DocumentSnapshot<Object?>?, bool)> whereClause(
      Query<Object?> Function(CollectionReference<Object?> p1) queryBuilder,
      [DocumentSnapshot<Object?>? lastDocument]) {
    // TODO: implement whereClause
    throw UnimplementedError();
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
