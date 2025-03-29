import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/database_service.dart/idatabase_service.dart';
import 'package:meta/meta.dart';

import '../../../../models/category.dart';

part 'category_parent_dialog_state.dart';

class CategoryParentDialogCubit extends Cubit<CategoryParentDialogState> {
  IdatabaseService dbService;
  CategoryParentDialogCubit({required this.dbService})
      : super(CategoryParentDialogState.initial());

  Future<void> fetchCategories() async {
    emit(state.copyWith(isLoading: true));
    var (result, lastDocument) = await dbService.getAll(10);

    if (result.isNotEmpty) {
      emit(state.copyWith(isLoading: false, categories: result));

      print("my result");
      print(state.categories);

      print("my result");
    } else {
      emit(state.copyWith(error: "Could not load categories"));
    }
  }

  void selectCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }
}
