import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../../database_service.dart/idatabase_service.dart';
import '../../../models/category.dart';

part 'fetch_category_event.dart';
part 'fetch_category_state.dart';

class FetchCategoryBloc extends Bloc<FetchCategoryEvent, FetchCategoryState> {
  final IdatabaseService dbService;

  FetchCategoryBloc(this.dbService) : super(FetchCategoryState.initial()) {
    on<FetchCategories>(_onFetchCategories);
  }

  Future<void> _onFetchCategories(
    FetchCategories event,
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
