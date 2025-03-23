part of 'fetch_product_bloc.dart';

@immutable
class FetchProductState {
  final List<Product> products;
  final bool isLoading;
  final bool hasReachedMax;
  final String? error;
  final DocumentSnapshot? lastDocument;

  const FetchProductState({
    this.products = const [],
    this.isLoading = false,
    this.hasReachedMax = false,
    this.error,
    this.lastDocument,
  });

  /// Factory constructor for initial state
  factory FetchProductState.initial() {
    return const FetchProductState();
  }

  /// Creates a new instance with updated values
  FetchProductState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? hasReachedMax,
    String? error,
    DocumentSnapshot? lastDocument,
  }) {
    return FetchProductState(
      products: products ?? List.from(this.products), // Deep copy
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      error: error, // Allows setting error to null explicitly
      lastDocument: lastDocument ?? this.lastDocument,
    );
  }

  /// Ensures proper equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FetchProductState &&
        ListEquality().equals(other.products, products) &&
        other.isLoading == isLoading &&
        other.hasReachedMax == hasReachedMax &&
        other.error == error &&
        other.lastDocument == lastDocument;
  }

  /// Generates a unique hash code for the object
  @override
  int get hashCode => Object.hash(
        Object.hashAll(products),
        isLoading,
        hasReachedMax,
        error,
        lastDocument,
      );

  /// Provides a readable representation for debugging
  @override
  String toString() {
    return 'FetchProductState(products: ${products.length} items, '
        'isLoading: $isLoading, hasReachedMax: $hasReachedMax, '
        'error: $error, lastDocument: $lastDocument)';
  }
}
