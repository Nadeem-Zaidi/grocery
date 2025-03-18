import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../database_service.dart/idatabase_service.dart';
import '../models/category.dart';

part 'category_update_event.dart';
part 'category_update_state.dart';

class CategoryUpdateBloc
    extends Bloc<CategoryUpdateEvent, CategoryUpdateState> {
  IdatabaseService dbService;

  CategoryUpdateBloc({required this.dbService})
      : super(CategoryUpdateState.initial()) {
    on<CategoryUpdateEvent>((event, emit) async {
      switch (event) {
        case InitializeExisting(
            id: String id,
            name: String name,
            parent: String parent,
            path: String path,
            url: String url,
          ):
          initializeExisting(emit, id, name, parent, path, url);
      }
    });
  }

  initializeExisting(Emitter<CategoryUpdateState> emit, String id, String name,
      String parent, String path, String url) {
    emit(state.copyWith(
        id: id,
        existingName: name,
        existingParent: parent,
        existingPath: path,
        uploadedImage: url));
  }

  void difference(Emitter<CategoryUpdateState> emit) {
    Map<String, dynamic> existing = {
      "name": state.existingName,
      "parent": state.existingParent,
      "path": state.existingPath
    };

    Map<String, dynamic> current = {
      "name": state.nameToUpdate,
      "parent": state.parentToUpdate,
      "path": state.pathToUpdate
    };
  }

  fetchCategoryToUpdate(Emitter<CategoryUpdateState> emit, String id,
      String name, String parent, String path) async {
    emit(state.copyWith(isFetching: true));
    emit(state.copyWith(
        existingName: name, existingParent: parent, existingPath: path));
    try {
      Category category = await dbService.getById(id);
      if (category.id != null) {
        emit(state.copyWith(category: category, isFetching: false));
      }
    } catch (e) {
      emit(state.copyWith(isFetching: false, error: e.toString()));
    } finally {}
  }
}
