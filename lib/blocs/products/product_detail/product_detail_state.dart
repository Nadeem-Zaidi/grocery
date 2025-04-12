part of 'product_detail_bloc.dart';

class ProductDetailState extends Equatable {
  final Product? product;
  final bool isLoading;
  final String? error;

  const ProductDetailState({
    this.product,
    this.isLoading = false,
    this.error,
  });

  ProductDetailState copyWith({
    Product? product,
    bool? isLoading,
    String? error,
  }) {
    return ProductDetailState(
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  factory ProductDetailState.initial() {
    return ProductDetailState(product: null, isLoading: false, error: null);
  }

  @override
  List<Object?> get props => [product, isLoading, error];
}
