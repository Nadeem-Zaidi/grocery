part of 'select_category_cubit.dart';

class SelectCategoryState extends Equatable {
  final Category? selectedCategory;
  final bool isLoading;
  final String? error;

  const SelectCategoryState({
    this.selectedCategory,
    this.isLoading = false,
    this.error,
  });

  factory SelectCategoryState.initial() {
    return const SelectCategoryState();
  }

  SelectCategoryState copyWith({
    Category? selectedCategory,
    bool? isLoading,
    String? error,
  }) {
    return SelectCategoryState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [selectedCategory, isLoading, error];
}
