import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/blocs/section/sectopm_bloc/section_builder_bloc.dart';
import 'package:grocery_app/database_service.dart/dashboard/dashboard.dart';
// import 'package:grocery_app/models/sections/section.dart';
import 'package:grocery_app/database_service.dart/dashboard/section.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardState.initial()) {
    on<DashboardEvent>((event, emit) {});
    on<AddSection>(_addSection);
    on<RemoveSection>(_removeSection);
    on<SavePage>(_savePage);
    on<AddSectionToSave>(_addSectionToSave);
  }

  void _addSectionToSave(AddSectionToSave event, Emitter<DashboardState> emit) {
    state.dashBoard.sections[event.section.id.toString()] = event.section;
    emit(state.copyWith(
        dashBoard:
            state.dashBoard.copyWith(sections: {...state.dashBoard.sections})));
  }

  void _addSection(AddSection event, Emitter<DashboardState> emit) {
    try {
      Map<String, Section> section = {};
      section[event.section.id.toString()] = event.section;
      emit(state.copyWith(
          dashBoard: state.dashBoard
              .copyWith(sections: {...state.dashBoard.sections, ...section})));
    } catch (error) {
      print(
          "Error in adding the section in _addSection due to error==>${error.toString()}");
      emit(state.copyWith(
          error: "Cannot add section.See the logs for more details"));
    }
  }

  void _removeSection(RemoveSection event, Emitter<DashboardState> emit) {
    try {
      // if (event.id != null && event.id.toString().isNotEmpty) {
      //   //remove from the data base and then from the list
      // } else {
      //   List<Section> sections = List<Section>.from(state.sections)
      //     ..removeAt(event.index);
      //   emit(state.copyWith(sections: sections));
      // }
    } catch (error) {
      print(
          "Error in adding the section in _removeSection due to error==>${error.toString()}");
      emit(state.copyWith(
          error: "Cannot remove section.See the logs for more details"));
    }
  }

  Future<void> _savePage(SavePage event, Emitter<DashboardState> emit) async {
    print(state.dashBoard.toMap());
  }
}
