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
