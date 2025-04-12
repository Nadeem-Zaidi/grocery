import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/category.dart';

part 'select_category_state.dart';

class SelectCategoryCubit extends Cubit<SelectCategoryState> {
  SelectCategoryCubit() : super(SelectCategoryState.initial());
  void selectCategory(Category? category) {
    try {
      state.copyWith(isLoading: true);
      state.copyWith(isLoading: false, selectedCategory: category);
    } catch (e) {
      state.copyWith(error: "Error in selecting category", isLoading: false);
    }
  }
}
