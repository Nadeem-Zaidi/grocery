part of 'fetch_category_bloc.dart';

@immutable
class FetchCategoryState {
  final List<Category> categories; // Changed from List<dynamic>
  final bool isFetching;
  final bool hasReachedMax;
  final DocumentSnapshot? lastDocument;
  final String? error;

  FetchCategoryState({
    required this.categories,
    required this.isFetching,
    required this.hasReachedMax,
    this.lastDocument,
    this.error,
  });

  factory FetchCategoryState.initial() => FetchCategoryState(
        categories: [],
        isFetching: false,
        hasReachedMax: false,
      );

  FetchCategoryState copyWith({
    List<Category>? categories,
    bool? isFetching,
    bool? hasReachedMax,
    DocumentSnapshot? lastDocument,
    String? error,
  }) {
    return FetchCategoryState(
      categories: categories ?? this.categories,
      isFetching: isFetching ?? this.isFetching,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      lastDocument: lastDocument ?? this.lastDocument,
      error: error ?? this.error,
    );
  }
}
