import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:collection/collection.dart';
part 'dashboard_builder_state.dart';

class DashboardBuilderCubit extends Cubit<DashboardBuilderState> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DashboardBuilderCubit() : super(DashboardBuilderState.initial());

  Future<void> fetchSections() async {
    try {
      var data = firestore.collection("sections").get();
    } catch (e) {}
  }
}
