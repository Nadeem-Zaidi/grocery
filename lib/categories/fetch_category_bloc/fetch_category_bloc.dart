import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../database_service.dart/idatabase_service.dart';

part 'fetch_category_event.dart';
part 'fetch_category_state.dart';

class FetchCategoryBloc extends Bloc<FetchCategoryEvent, FetchCategoryState> {
  IdatabaseService dbService;
  FetchCategoryBloc(this.dbService) : super(FetchCategoryState.initial()) {
    on<FetchCategoryEvent>((event, emit) async {
      switch (event) {
        case FetchCategories():
          await _fetchCategories(emit);
      }
    });
  }
  Future<void> _fetchCategories(Emitter<FetchCategoryState> emit) async {
    emit(state.copyWith(isFetching: true));
    try {
      var (newCategories, newLastDocument) =
          await dbService.getAll(8, state.lastDocument);

      if (newCategories.isEmpty) {
        emit(state.copyWith(hasReachedMax: true, isFetching: false));
      } else {
        emit(state.copyWith(
          categories: List.of(state.categories)..addAll(newCategories),
          lastDocument: newLastDocument,
          isFetching: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isFetching: false));
    }
  }
}
