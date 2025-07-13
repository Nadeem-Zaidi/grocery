part of 'fetch_category_bloc.dart';

@immutable
class FetchCategoryState extends Equatable {
  final List<Category> categories;
  final List<Category> childrenCategories;
  final List<Productt> products;
  final bool categoryLoading;
  final bool productLoading;
  final bool hasReachedMax;
  final bool hasReachedProductMax;
  final DocumentSnapshot? lastDocument;
  final DocumentSnapshot? lastProductDocument;
  final String? currentChildCat;
  final String? defaultChildCat;
  final String? categoryName;
  final String? error;
  final Category? selectedCategory;

  /// Default constructor
  const FetchCategoryState({
    this.categories = const [],
    this.childrenCategories = const [],
    this.products = const [],
    this.categoryLoading = false,
    this.productLoading = false,
    this.hasReachedMax = false,
    this.hasReachedProductMax = false,
    this.lastDocument,
    this.lastProductDocument,
    this.categoryName,
    this.error,
    this.defaultChildCat,
    this.currentChildCat,
    this.selectedCategory,
  });

  /// Initial state
  const FetchCategoryState.initial() : this();

  /// Loading state
  const FetchCategoryState.loading() : this(categoryLoading: true);

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
          categoryLoading: false,
          error: null,
        );

  /// Failure state with error message
  const FetchCategoryState.failure(String error)
      : this(error: error, categoryLoading: false);

  @override
  List<Object?> get props => [
        categories,
        childrenCategories,
        products,
        categoryLoading,
        hasReachedMax,
        hasReachedProductMax,
        lastDocument,
        lastProductDocument,
        categoryName,
        defaultChildCat,
        currentChildCat,
        error,
        selectedCategory
      ];

  /// Create a copy with modified values
  FetchCategoryState copyWith({
    List<Category>? categories,
    List<Category>? childrenCategories,
    List<Productt>? products,
    bool? categoryLoading,
    bool? productLoading,
    bool? hasReachedMax,
    bool? hasReachedProductMax,
    DocumentSnapshot? lastDocument,
    DocumentSnapshot? lastProductDocument,
    String? categoryName,
    String? defaultChildCat,
    String? currentChildCat,
    String? error,
    Category? selectedCategory,
  }) {
    return FetchCategoryState(
        categories: categories ?? this.categories,
        childrenCategories: childrenCategories ?? this.childrenCategories,
        products: products ?? this.products,
        categoryLoading: categoryLoading ?? this.categoryLoading,
        productLoading: productLoading ?? this.productLoading,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        hasReachedProductMax: hasReachedProductMax ?? this.hasReachedProductMax,
        lastDocument: lastDocument ?? this.lastDocument,
        lastProductDocument: lastProductDocument ?? this.lastProductDocument,
        defaultChildCat: defaultChildCat ?? this.defaultChildCat,
        currentChildCat: currentChildCat ?? this.currentChildCat,
        categoryName: categoryName ?? this.categoryName,
        error: error ?? this.error,
        selectedCategory: selectedCategory ?? this.selectedCategory);
  }

  @override
  String toString() => '''
FetchCategoryState {
  categories: ${categories.length},
  childrenCategories: ${childrenCategories.length},
  products:${products.length},
  categoryLoading: $categoryLoading,
  productLoading:$productLoading,
  hasReachedMax: $hasReachedMax,
  hasReachedProductMax:$hasReachedProductMax,
  lastDocument: $lastDocument,
  lastProductDocument: $lastProductDocument,
  defaultChildCat:$defaultChildCat
  currentChildCat:$currentChildCat
  categoryName:$categoryName
  error: $error
  selectedCategory:$selectedCategory
}
''';
}
