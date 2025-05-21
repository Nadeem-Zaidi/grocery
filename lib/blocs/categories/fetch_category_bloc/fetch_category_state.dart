part of 'fetch_category_bloc.dart';

@immutable
class FetchCategoryState extends Equatable {
  final List<Category> categories;
  final List<Category> childrenCategories;
  final List<Product> products;
  final bool isFetching;
  final bool hasReachedMax;
  final bool hasReachedProductMax;
  final DocumentSnapshot? lastDocument;
  final DocumentSnapshot? lastProductDocument;
  final String? currentChildCat;
  final String? defaultChildCat;
  final String? categoryName;
  final String? error;

  /// Default constructor
  const FetchCategoryState({
    this.categories = const [],
    this.childrenCategories = const [],
    this.products = const [],
    this.isFetching = false,
    this.hasReachedMax = false,
    this.hasReachedProductMax = false,
    this.lastDocument,
    this.lastProductDocument,
    this.categoryName,
    this.error,
    this.defaultChildCat,
    this.currentChildCat,
  });

  /// Initial state
  const FetchCategoryState.initial() : this();

  /// Loading state
  const FetchCategoryState.loading() : this(isFetching: true);

  /// Success state after data is fetched
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

  /// Failure state with error message
  const FetchCategoryState.failure(String error)
      : this(error: error, isFetching: false);

  @override
  List<Object?> get props => [
        categories,
        childrenCategories,
        products,
        isFetching,
        hasReachedMax,
        hasReachedProductMax,
        lastDocument,
        lastProductDocument,
        categoryName,
        defaultChildCat,
        currentChildCat,
        error,
      ];

  /// Create a copy with modified values
  FetchCategoryState copyWith({
    List<Category>? categories,
    List<Category>? childrenCategories,
    List<Product>? products,
    bool? isFetching,
    bool? hasReachedMax,
    bool? hasReachedProductMax,
    DocumentSnapshot? lastDocument,
    DocumentSnapshot? lastProductDocument,
    String? categoryName,
    String? defaultChildCat,
    String? currentChildCat,
    String? error,
  }) {
    return FetchCategoryState(
      categories: categories ?? this.categories,
      childrenCategories: childrenCategories ?? this.childrenCategories,
      products: products ?? this.products,
      isFetching: isFetching ?? this.isFetching,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      hasReachedProductMax: hasReachedProductMax ?? this.hasReachedProductMax,
      lastDocument: lastDocument ?? this.lastDocument,
      lastProductDocument: lastProductDocument ?? this.lastProductDocument,
      defaultChildCat: defaultChildCat ?? this.defaultChildCat,
      currentChildCat: currentChildCat ?? this.currentChildCat,
      categoryName: categoryName ?? this.categoryName,
      error: error ?? this.error,
    );
  }

  @override
  String toString() => '''
FetchCategoryState {
  categories: ${categories.length},
  childrenCategories: ${childrenCategories.length},
  products:${products.length},
  isFetching: $isFetching,
  hasReachedMax: $hasReachedMax,
  hasReachedProductMax:$hasReachedProductMax,
  lastDocument: $lastDocument,
  lastProductDocument: $lastProductDocument,
  defaultChildCat:$defaultChildCat
  currentChildCat:$currentChildCat
  categoryName:$categoryName
  error: $error
}
''';
}
