import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../database_service.dart/idatabase_service.dart';
import '../../../models/category.dart';

part 'fetch_category_event.dart';
part 'fetch_category_state.dart';

class FetchCategoryBloc extends Bloc<FetchCategoryEvent, FetchCategoryState> {
  final IdatabaseService dbService;

  FetchCategoryBloc(this.dbService) : super(FetchCategoryState.initial()) {
    on<FetchCategoryEvent>((event, emit) async {
      switch (event) {
        case FetchCategories():
          await _onFetchCategories(emit);

        case FetchCategoryChildren(categoryId: String id):
          await _fetchCategoryChildren(emit, id);
      }
    });
  }

  Future<void> _fetchCategoryChildren(
      Emitter<FetchCategoryState> emit, String id) async {
    try {
      emit(state.copyWith(isFetching: true));
      List<Category> childCategories = await dbService.whereClause(
              (collection) => collection.where('parent', isEqualTo: id))
          as List<Category>;
      if (childCategories.isNotEmpty) {
        emit(state.copyWith(
            childrenCategories: childCategories, isFetching: false));
      }
    } catch (e) {
      print("Can not fetch the child category due to error ==> ${e}");
      emit(state.copyWith(isFetching: false, error: e.toString()));
    }
  }

  Future<void> _onFetchCategories(
    Emitter<FetchCategoryState> emit,
  ) async {
    // Don't fetch if we're already loading or have reached max
    if (state.isFetching || state.hasReachedMax) return;

    emit(state.copyWith(isFetching: true));

    try {
      final (newCategories, newLastDocument) = await dbService.getAll(
        10, // Your page size
        state.lastDocument, // Pass the last document for pagination
      );

      if (newCategories.isEmpty) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        emit(state.copyWith(
          categories: [...state.categories, ...newCategories],
          lastDocument: newLastDocument,
        ));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isFetching: false));
    }
  }
}
