import 'package:bloc/bloc.dart';
import 'package:grocery_app/database_service.dart/idatabase_service.dart';
import 'package:meta/meta.dart';

import '../../category.dart';

part 'category_parent_dialog_state.dart';

class CategoryParentDialogCubit extends Cubit<CategoryParentDialogState> {
  IdatabaseService dbService;
  CategoryParentDialogCubit({required this.dbService})
      : super(CategoryParentDialogState.initial());

  Future<void> fetchCategories() async {
    emit(state.copyWith(isLoading: true));
    var result = await dbService.getAll();
    if (result.isNotEmpty) {
      emit(state.copyWith(
          isLoading: false, categories: result as List<Category>));
    } else {
      emit(state.copyWith(error: "Could not load categories"));
    }
  }
}
