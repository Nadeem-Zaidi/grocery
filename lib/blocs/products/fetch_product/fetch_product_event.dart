part of 'fetch_product_bloc.dart';

@immutable
sealed class FetchProductEvent {}

@immutable
class FetchProducts extends FetchProductEvent {
  final String categoryString;
  FetchProducts(this.categoryString);
}

@immutable
class FetchProductWhere extends FetchProductEvent {
  final String categoryString;
  FetchProductWhere(this.categoryString);
}

// @immutable
// class ProductStream extends FetchProductEvent {
//   final List<Product> products;
//   ProductStream({required this.products});
// }

// @immutable
// class ProductsUpdated extends FetchProductEvent {
//   final List<Product> products;
//   DocumentSnapshot? lastDocument;
//   ProductsUpdated({required this.products, this.lastDocument});
// }

// @immutable
// class LoadProducts extends FetchProductEvent {}

// @immutable
// class LoadMore extends FetchProductEvent {}

// @immutable
// class ProductNext extends FetchProductEvent {
//   final List<Product> products;
//   DocumentSnapshot? lastDocument;
//   ProductNext({required this.products, this.lastDocument});
// }
