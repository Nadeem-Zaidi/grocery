part of 'product_detail_bloc.dart';

sealed class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object> get props => [];
}

@immutable
class FetchDetails extends ProductDetailEvent {
  final String productId;
  const FetchDetails(this.productId);
}
