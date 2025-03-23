part of 'product_bloc.dart';

@immutable
class ProductState {
  final List<Product> products;
  final bool isLoading;
  String? error;

  ProductState({this.products = const [], this.isLoading = false, this.error});

  /// Factory constructor for initial state
  factory ProductState.initial() {
    return ProductState(error: null);
  }

  /// Creates a new instance with updated values
  ProductState copyWith(
      {List<Product>? products, bool? isLoading, String? error}) {
    return ProductState(
        products: products ?? List.from(this.products), // Deep copy of the list
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error);
  }

  /// Ensures proper equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductState &&
        ListEquality().equals(other.products, products) &&
        other.isLoading == isLoading;
  }

  /// Generates a unique hash code for the object
  @override
  int get hashCode => Object.hash(
        Object.hashAll(products), // Properly hashes the list
        isLoading,
      );

  /// Provides a readable representation for debugging
  @override
  String toString() {
    return 'ProductState(products: ${products.length} items, isLoading: $isLoading)';
  }
}
