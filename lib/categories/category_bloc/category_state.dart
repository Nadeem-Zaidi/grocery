part of 'category_bloc.dart';

@immutable
class CategoryState {
  final List<category.Category> categories;
  final bool isLoading;
  String? error;

  CategoryState(
      {this.error, required this.categories, required this.isLoading});

  factory CategoryState.initial() {
    return CategoryState(error: null, categories: [], isLoading: false);
  }

  CategoryState copyWith(
      {List<category.Category>? categories, bool? isLoading, String? error}) {
    return CategoryState(
        categories: categories ?? this.categories,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryState &&
        listEquals(other.categories, categories) &&
        other.isLoading == isLoading;
  }

  @override
  int get hashCode => categories.hashCode ^ isLoading.hashCode;

  @override
  String toString() =>
      'CategoryState(categories: $categories, isLoading: $isLoading)';
}
