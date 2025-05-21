part of 'product_detail_bloc.dart';

class ProductDetailState extends Equatable {
  final Product? product;
  final bool isLoading;
  final bool viewProductDetails;
  final bool showHighlights;
  final bool showInfo;
  final String? error;

  const ProductDetailState({
    this.product,
    this.isLoading = false,
    this.viewProductDetails = false,
    this.showHighlights = false,
    this.showInfo = false,
    this.error,
  });

  ProductDetailState copyWith({
    Product? product,
    bool? isLoading,
    String? error,
    bool? viewProductDetails,
    bool? showHighlights,
    bool? showInfo,
  }) {
    return ProductDetailState(
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      viewProductDetails: viewProductDetails ?? this.viewProductDetails,
      showHighlights: showHighlights ?? this.showHighlights,
      showInfo: showInfo ?? this.showInfo,
    );
  }

  factory ProductDetailState.initial() {
    return const ProductDetailState();
  }

  @override
  List<Object?> get props => [
        product,
        isLoading,
        viewProductDetails,
        showHighlights,
        showInfo,
        error,
      ];

  @override
  String toString() {
    return 'ProductDetailState(product: $product, isLoading: $isLoading, '
        'viewProductDetails: $viewProductDetails, showHighlights: $showHighlights, '
        'showInfo: $showInfo, error: $error)';
  }
}
