part of 'new_product_bloc.dart';

class NewProductState extends Equatable {
  final cat.Category? category;
  final List<cat.Category> categories;
  bool isLoading;
  final String? error;
  bool hasReachedMax;
  DocumentSnapshot? lastDocument;

  NewProductState(
      {required this.category,
      this.categories = const [],
      this.isLoading = false,
      this.hasReachedMax = false,
      required this.error,
      this.lastDocument});

  factory NewProductState.initial() {
    return NewProductState(category: null, error: null);
  }

  NewProductState copyWith({
    cat.Category? category,
    List<cat.Category>? categories,
    bool? isLoading,
    bool? hasReachedMax,
    String? error,
    DocumentSnapshot? lastDocument,
  }) {
    return NewProductState(
        category: category ?? this.category,
        categories: categories ?? this.categories,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        lastDocument: lastDocument ?? this.lastDocument);
  }

  @override
  List<Object?> get props =>
      [category, isLoading, hasReachedMax, error, categories, lastDocument];
}
