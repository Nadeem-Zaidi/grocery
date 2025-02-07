import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:grocery_app/database_service.dart/idatabase_service.dart';
import 'package:meta/meta.dart';

import '../category.dart' as category;
import '../category.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  IdatabaseService dbService;
  CategoryBloc({required this.dbService}) : super(CategoryState.initial()) {
    on<CategoryEvent>((event, emit) async {
      switch (event) {
        case FetchAllCategories():
          await _fetchAllCategories(emit);
          throw UnimplementedError();
        case FetchCategory(categoryId: String categoryId):
          await _fetchCategory(emit, categoryId);
        case CreateCategory(categoryData: Map<String, dynamic> categoryData):
          await _createCategory(emit, categoryData);
      }
    });
  }

  Future<void> _fetchAllCategories(Emitter<CategoryState> emit) async {
    emit(state.copyWith(isLoading: true));
    List<dynamic>? categories = await dbService.getAll();

    if (categories.isNotEmpty) {
      emit(state.copyWith(
          categories: categories as List<category.Category>, isLoading: false));
    }
    emit(state.copyWith(error: "Could not fetch categories"));
  }

  Future<void> _fetchCategory(Emitter<CategoryState> emit, String id) async {
    emit(state.copyWith(isLoading: true));
    List<dynamic> cat = [];
    var cg = await dbService.getById(id);
    if (cg) {
      cat.add(cg);
      emit(state.copyWith(
          categories: cat as List<category.Category>, isLoading: false));
    } else {
      emit(state.copyWith(error: "could not load category"));
    }
  }

  Future<void> _createCategory(
      Emitter<CategoryState> emit, Map<String, dynamic> categoryData) async {
    emit(state.copyWith(isLoading: true));

    var result = await dbService.create(categoryData);
    if (result) {
      emit(state.copyWith(categories: result as List<category.Category>));
    } else {
      emit(state.copyWith(error: "Category could not be created"));
    }
  }
}
