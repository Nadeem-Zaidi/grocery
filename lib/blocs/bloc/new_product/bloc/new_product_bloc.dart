import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:grocery_app/database_service.dart/IDBService.dart';
import '../../../../models/category.dart' as cat;

part 'new_product_event.dart';
part 'new_product_state.dart';

class NewProductBloc extends Bloc<NewProductEvent, NewProductState> {
  IDBService<cat.Category> dbService;
  NewProductBloc({required this.dbService}) : super(NewProductState.initial()) {
    on<NewProductEvent>((event, emit) async {
      switch (event) {
        case NewProductSelectCategoryEvent(category: cat.Category c):
          await _selectCategory(emit, c);
        case FetchCategoriesForNewProduct():
          await _showCategoryList(emit);
      }
    });
  }
  Future<void> _selectCategory(
      Emitter<NewProductState> emit, cat.Category category) async {
    try {
      emit(state.copyWith(isLoading: true));
      emit(state.copyWith(category: category));
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(
          error: "Error in selecting category", isLoading: false));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _showCategoryList(Emitter<NewProductState> emit) async {
    try {
      var (categories, lastDocument) = await dbService.getAll(10, "name");
      if (categories.isEmpty) {
        emit(state
            .copyWith(isLoading: false, hasReachedMax: true, categories: []));
        return;
      }
      emit(state.copyWith(
          isLoading: false,
          categories: categories,
          lastDocument: lastDocument));
    } catch (e) {
      print("error in loading categories==>${e.toString()}");
      emit(state.copyWith(
          error: "Something went wrong in fetching categories",
          isLoading: false));
    }
  }
}
