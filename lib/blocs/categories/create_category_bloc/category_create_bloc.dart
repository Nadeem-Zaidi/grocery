import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:grocery_app/database_service.dart/idatabase_service.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/category.dart' as category;

part 'category_create_event.dart';
part 'category_create_state.dart';

class CreateCategoryBloc
    extends Bloc<CreateCategoryEvent, CreateCategoryState> {
  IdatabaseService dbService;
  final ImagePicker _picker = ImagePicker();
  CreateCategoryBloc({required this.dbService})
      : super(CreateCategoryState.initial()) {
    on<CreateCategoryEvent>((event, emit) async {
      switch (event) {
        // case FetchAllCategories():
        //   await _fetchAllCategories(emit);
        //   throw UnimplementedError();
        // case FetchCategory(categoryId: String categoryId):
        //   await _fetchCategory(emit, categoryId);
        case CreateCategory():
          await _createCategory(emit);
        case PickImage():
          await _pickImage(emit);
        case Setpath(fixed: String fixed, parentId: String parentId):
          _setPath(emit, fixed, parentId);

        case ResetPatg():
          await _resetpath(emit);
        case UpdateCategoryPath(userInput: String userInput):
          _updateCategoryPath(emit, userInput);
        case UpdateCategory():
          // TODO: Handle this case.
          throw UnimplementedError();
      }
    });
  }

  // Future<void> _fetchAllCategories(Emitter<CategoryState> emit) async {
  //   emit(state.copyWith(isLoading: true));
  //   List<dynamic>? categories = await dbService.getAll();

  //   if (categories.isNotEmpty) {
  //     emit(state.copyWith(
  //         categories: categories as List<category.Category>, isLoading: false));
  //   }
  //   emit(state.copyWith(error: "Could not fetch categories"));
  // }

  // Future<void> _fetchCategory(Emitter<CategoryState> emit, String id) async {
  //   emit(state.copyWith(isLoading: true));
  //   List<dynamic> cat = [];
  //   var cg = await dbService.getById(id);
  //   if (cg) {
  //     cat.add(cg);
  //     emit(state.copyWith(
  //         categories: cat as List<category.Category>, isLoading: false));
  //   } else {
  //     emit(state.copyWith(error: "could not load category"));
  //   }
  // }

  Future<void> _pickImage(Emitter<CreateCategoryState> emit) async {
    emit(state.copyWith(isLoading: true));
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      emit(state.copyWith(isLoading: false, imageFile: File(pickedFile.path)));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _setPath(
      Emitter<CreateCategoryState> emit, String fixed, String parentId) {
    emit(state.copyWith(
      fixedPath: fixed,
      path: fixed,
      parentId: parentId,
    ));
  }

  void _updateCategoryPath(
      Emitter<CreateCategoryState> emit, String userInput) {
    if (state.fixedPath == null) {
      return;
    }

    var newPath = userInput.isNotEmpty
        ? "${state.fixedPath}/$userInput"
        : state.fixedPath;

    emit(state.copyWith(path: newPath, name: userInput));
  }

  Future<void> _createCategory(Emitter<CreateCategoryState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      if (state.name == null) {
        throw Exception("Category name cannot be null");
      }
      String fileName = state.name!;

      // Ensure an image is selected
      if (state.imageFile == null) {
        throw Exception("No image selected for category.");
      }

      Reference storageRef =
          FirebaseStorage.instance.ref().child("images/$fileName.jpg");

      UploadTask uploadTask = storageRef.putFile(state.imageFile!);
      TaskSnapshot snapshot = await uploadTask;

      String url = await snapshot.ref.getDownloadURL();

      if (url.isEmpty) {
        throw Exception("Image upload failed, no URL returned.");
      }

      // Save the category and check the result
      var result = await dbService.create(state.name!, state.parentId, url);

      // if (result == null || result.isEmpty) {
      //   throw Exception("Failed to create category.");
      // }

      var r = [];
      r.add(result);

      emit(state.copyWith(
        categories: r,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _resetpath(Emitter<CreateCategoryState> emit) async {
    emit(state.copyWith(path: ""));
  }

  Future<void> _updateCategory(
      Emitter<CreateCategoryState> emit, String id) async {
    emit(state.copyWith(isLoading: true));
    try {
      Map<String, dynamic> categoryDataToUpdate = {
        "id": id,
      };
      await dbService.update(categoryDataToUpdate);
    } catch (e) {}
  }
}
