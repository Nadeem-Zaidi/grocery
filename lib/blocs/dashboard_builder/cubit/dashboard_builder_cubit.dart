import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:grocery_app/database_service.dart/idatabase_service.dart';
import 'package:grocery_app/models/sections/section.dart';
part 'dashboard_builder_state.dart';

class DashboardBuilderCubit extends Cubit<DashboardBuilderState> {
  IdatabaseService dbService;
  DashboardBuilderCubit({required this.dbService})
      : super(DashboardBuilderState.initial());

  Future<void> fetchSections() async {
    try {
      state.copyWith(isLoading: true);
      var (sectionList, newLastDocument) =
          await dbService.getAll(2, state.lastDocument);

      if (sectionList.isEmpty) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        emit(state.copyWith(
            sections: [...state.sections, ...sectionList],
            lastDocument: newLastDocument));

        print(state.sections);
      }
    } catch (e) {
      print(e.toString());
      emit(state.copyWith(error: "Error in fetching section"));
    } finally {
      state.copyWith(isLoading: false);
    }
  }
}
