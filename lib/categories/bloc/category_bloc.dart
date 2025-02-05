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
          _fetchAllCategories(emit);
          throw UnimplementedError();
        case FetchCategory(categoryId: String categoryId):
          _fetchCategory(emit, categoryId);
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
}
