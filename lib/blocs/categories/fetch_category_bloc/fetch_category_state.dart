part of 'fetch_category_bloc.dart';

@immutable
class FetchCategoryState extends Equatable {
  final List<Category> categories;
  final List<Category> childrenCategories;
  final bool isFetching;
  final bool hasReachedMax;
  final DocumentSnapshot? lastDocument;
  final String? error;

  const FetchCategoryState({
    this.categories = const [],
    this.childrenCategories = const [],
    this.isFetching = false,
    this.hasReachedMax = false,
    this.lastDocument,
    this.error,
  });

  // Named constructors for explicit states
  const FetchCategoryState.initial() : this();

  const FetchCategoryState.loading() : this(isFetching: true, error: null);

  const FetchCategoryState.success({
    required List<Category> categories,
    required List<Category> childrenCategories,
    required bool hasReachedMax,
    DocumentSnapshot? lastDocument,
  }) : this(
          categories: categories,
          childrenCategories: childrenCategories,
          hasReachedMax: hasReachedMax,
          lastDocument: lastDocument,
          isFetching: false,
          error: null,
        );

  const FetchCategoryState.failure(String error)
      : this(error: error, isFetching: false);

  @override
  List<Object?> get props => [
        categories,
        childrenCategories,
        isFetching,
        hasReachedMax,
        lastDocument,
        error,
      ];

  FetchCategoryState copyWith({
    List<Category>? categories,
    List<Category>? childrenCategories,
    bool? isFetching,
    bool? hasReachedMax,
    DocumentSnapshot? lastDocument,
    String? error,
  }) {
    return FetchCategoryState(
      categories: categories ?? this.categories,
      childrenCategories: childrenCategories ?? this.childrenCategories,
      isFetching: isFetching ?? this.isFetching,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      lastDocument: lastDocument ?? this.lastDocument,
      error: error ?? this.error,
    );
  }

  @override
  String toString() => '''
    FetchCategoryState {
      categories: ${categories.length},
      childrenCategories: ${childrenCategories.length},
      isFetching: $isFetching,
      hasReachedMax: $hasReachedMax,
      lastDocument: $lastDocument,
      error: $error
    }
  ''';
}
