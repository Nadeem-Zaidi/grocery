import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../database_service.dart/idatabase_service.dart';
import '../../../models/category.dart';

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

        case CheckForDifference(value: String? value):
          checkForDifference(emit, value);
        case UpdateExistingName(value: String? value):
          updateExistingName(emit, value);
        case UpdateCategory():
          await updateCategory(emit);
      }
    });
  }

  void initializeExisting(Emitter<CategoryUpdateState> emit, String id,
      String name, String parent, String path, String url) {
    List<String> pathList = path.split("/");
    String fixedPath = pathList.sublist(0, pathList.length - 1).join("/");

    emit(state.copyWith(
        id: id,
        existingName: name,
        existingParent: parent,
        fixedPath: fixedPath,
        existingPath: path,
        pathName: path,
        uploadedImage: url));
  }

  void _updateCategoryPath(
      Emitter<CategoryUpdateState> emit, String userInput) {
    if (state.fixedPath == null) {
      return;
    }

    var newPath = userInput.isNotEmpty
        ? "${state.fixedPath}/$userInput"
        : state.fixedPath;

    emit(state.copyWith(pathName: newPath, dynamicPath: userInput));
  }

  void updateExistingName(Emitter<CategoryUpdateState> emit, String? value) {
    if (state.fixedPath == null) {
      return;
    }

    var newPath =
        value!.isNotEmpty ? "${state.fixedPath}/$value" : state.fixedPath;

    emit(state.copyWith(pathName: newPath, dynamicPath: value));

    add(CheckForDifference(value: value));
  }

  void checkForDifference(Emitter<CategoryUpdateState> emit, String? value) {
    bool newShouldChange;

    if (value != state.existingName || state.existingPath != state.pathName) {
      newShouldChange = true;
    } else {
      newShouldChange = false;
    }

    if (state.shouldChange != newShouldChange) {
      emit(state.copyWith(shouldChange: newShouldChange));
    }
  }

  Future<void> fetchCategoryToUpdate(Emitter<CategoryUpdateState> emit,
      String id, String name, String parent, String path) async {
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

  Future<void> updateCategory(Emitter<CategoryUpdateState> emit) async {
    emit(state.copyWith(isFetching: true));
    String? categoryId = state.id;
    String? newName = state.dynamicPath;

    if (categoryId == null || categoryId.isEmpty) {
      throw ArgumentError("Category Id is required");
    }

    if (newName == null || newName.isEmpty) {
      throw ArgumentError("Valid name is required");
    }

    try {
      Category? category = await dbService.getById(categoryId);
      if (category == null) {
        return;
      }

      String? oldPath = category.path;
      String? parentId = category.parent;
      String newPath = newName;

      if (parentId != null) {
        Category? parentDoc = await dbService.getById(parentId);
        if (parentDoc != null) {
          String? parentPath = parentDoc.path;
          newPath = "$parentPath/$newName";
        }
      }

      // Update the current category
      Category updatedDoc = await dbService.update({
        "id": categoryId,
        "name": newName,
        "path": newPath,
      });

      // Update all child categories recursively
      List<Category> childrenCategories = await dbService.whereClause(
        (collection) => collection
            .where('path', isGreaterThanOrEqualTo: oldPath)
            .where('path', isLessThan: "$oldPath~"),
      );

      for (Category child in childrenCategories) {
        String? childId = child.id;
        String? childPath = child.path;

        if (childPath != null && oldPath != null) {
          String updatedChildPath = childPath.replaceFirst(oldPath, newPath);

          await dbService.update({
            "id": childId,
            "path": updatedChildPath,
          });
        }
      }
      emit(state.copyWith(isFetching: false, done: true));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isFetching: false));
    }
  }
}
