part of 'category_parent_dialog_cubit.dart';

@immutable
class CategoryParentDialogState {
  final List<dynamic> categories;
  final bool isLoading;
  String? selectedCategory;
  String? error;

  CategoryParentDialogState(
      {required this.categories,
      this.isLoading = false,
      this.error,
      this.selectedCategory});
  factory CategoryParentDialogState.initial() {
    return CategoryParentDialogState(
        categories: [], isLoading: false, error: null, selectedCategory: null);
  }

  CategoryParentDialogState copyWith(
      {List<dynamic>? categories,
      bool? isLoading,
      String? error,
      String? selectedCategory}) {
    return CategoryParentDialogState(
        categories: categories ?? this.categories,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        selectedCategory: selectedCategory ?? this.selectedCategory);
  }
}
