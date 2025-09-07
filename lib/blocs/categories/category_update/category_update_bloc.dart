import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/blocs/categories/create_category_bloc/category_create_bloc.dart';
import 'package:grocery_app/database_service.dart/IDBService.dart';
import 'package:grocery_app/utils/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../../database_service.dart/idatabase_service.dart';
import '../../../models/category.dart';

part 'category_update_event.dart';
part 'category_update_state.dart';

class CategoryUpdateBloc
    extends Bloc<CategoryUpdateEvent, CategoryUpdateState> {
  IDBService<Category> dbService;
  final ImagePicker _picker = ImagePicker();

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
        case PickImage():
          await _pickImage(emit);
      }
    });
  }

  Future<void> _pickImage(Emitter<CategoryUpdateState> emit) async {
    emit(state.copyWith(loadingImagePicker: true));
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        emit(state.copyWith(
            loadingImagePicker: false,
            imageFile: File(pickedFile.path),
            shouldChange: true));
      } else {
        throw Exception("Something went wrong in picking image");
      }
    } catch (e) {
      emit(state.copyWith(
        error: "Something went wrong in picking image",
        loadingImagePicker: false,
      ));
    }
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

    if (state.existingPath != state.pathName) {
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
      Category? category = await dbService.getById(id);
      if (category?.id != null) {
        emit(state.copyWith(category: category, isFetching: false));
      }
    } catch (e) {
      emit(state.copyWith(isFetching: false, error: e.toString()));
    } finally {}
  }

  Future<void> updateCategory(Emitter<CategoryUpdateState> emit) async {
    // Start loader
    emit(state.copyWith(isFetching: true, error: null, done: false));

    String? categoryId = state.id;
    String? newName = state.dynamicPath;
    String? newPath = newName;
    File? image = state.imageFile;
    String? updatedImageUrl;

    try {
      if (categoryId == null || categoryId.isEmpty) {
        throw ArgumentError("Category Id is required");
      }

      // Upload image (if present)
      if (image != null) {
        updatedImageUrl =
            await uploadImage("category", image, state.existingName.toString());
        if (updatedImageUrl == null || updatedImageUrl.isEmpty) {
          throw Exception(
              "Cannot update because updated image url is null or empty");
        }
      }

      if (newName != null && newName.isNotEmpty) {
        // Get category
        Category? category = await dbService.getById(categoryId);
        if (category == null) {
          throw Exception("Error in fetching category");
        }
        String? oldPath = category.path;

        // Get parentId and calculate new path
        String? parentId = category.parent;
        if (parentId != null && parentId.isNotEmpty) {
          Category? parentDoc = await dbService.getById(parentId);
          if (parentDoc != null) {
            String? parentPath = parentDoc.path;
            newPath = "$parentPath/$newName";
          }
        }

        // Run batch update
        await dbService.runInBatch((batch, c) async {
          // Update current category
          DocumentReference docRef = c.doc(categoryId);
          batch.update(docRef, {
            "name": newName,
            "path": newPath,
            if (updatedImageUrl != null && updatedImageUrl.isNotEmpty)
              "image": updatedImageUrl
          });

          // Update children categories
          List<Category> childrenCategories = await dbService.whereClause(
            (collection) => collection
                .where('path', isGreaterThanOrEqualTo: oldPath)
                .where('path', isLessThan: "$oldPath~"),
          ) as List<Category>;

          for (Category child in childrenCategories) {
            if (child.path != null && oldPath != null) {
              String updatedChildPath =
                  child.path!.replaceFirst(oldPath, newPath!);

              DocumentReference childRef = c.doc(child.id);
              batch.update(childRef, {"path": updatedChildPath});
            }
          }
        });

        // ✅ Success emit
        emit(state.copyWith(isFetching: false, done: true));
      } else {
        await dbService.update(Category(id: categoryId, url: updatedImageUrl),
            returnUpdatedDoc: false);
        emit(state.copyWith(isFetching: false, done: true));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isFetching: false));
    }
  }
}
