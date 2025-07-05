part of 'productcreationconfirm_bloc.dart';

class ProductCreationConfirmState extends Equatable {
  final Productt? product;
  final bool isFetching;
  final String? error;

  const ProductCreationConfirmState(
      {this.product, this.isFetching = false, this.error});
  factory ProductCreationConfirmState.initial() {
    return ProductCreationConfirmState();
  }

  ProductCreationConfirmState copyWith(
      {Productt? product, bool? isFetching, String? error}) {
    return ProductCreationConfirmState(
        product: product ?? this.product,
        isFetching: isFetching ?? this.isFetching,
        error: error ?? this.error);
  }

  @override
  List<Object?> get props => [product, isFetching, error];
}
