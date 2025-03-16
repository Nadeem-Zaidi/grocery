part of 'category_parent_dialog_cubit.dart';

@immutable
class CategoryParentDialogState {
  final List<dynamic> categories;
  final bool isLoading;
  final String? error;

  const CategoryParentDialogState(
      {required this.categories, this.isLoading = false, this.error});
  factory CategoryParentDialogState.initial() {
    return CategoryParentDialogState(
        categories: [], isLoading: false, error: null);
  }

  CategoryParentDialogState copyWith(
      {List<dynamic>? categories, bool? isLoading, String? error}) {
    return CategoryParentDialogState(
        categories: categories ?? this.categories,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error);
  }
}
