part of 'category_parent_dialog_cubit.dart';

@immutable
class CategoryParentDialogState {
  List<Category> categories = [];
  bool? isLoading;
  String? error;

  CategoryParentDialogState(
      {required this.categories, this.isLoading, this.error});
  factory CategoryParentDialogState.initial() {
    return CategoryParentDialogState(
        categories: [], isLoading: false, error: null);
  }

  CategoryParentDialogState copyWith(
      {List<Category>? categories, bool? isLoading, String? error}) {
    return CategoryParentDialogState(
        categories: categories ?? this.categories,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error);
  }
}
