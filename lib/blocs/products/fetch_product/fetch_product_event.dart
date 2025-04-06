part of 'fetch_product_bloc.dart';

@immutable
sealed class FetchProductEvent {}

// ignore: must_be_immutable
class FetchProducts extends FetchProductEvent {
  String categoryString;
  FetchProducts(this.categoryString);
}
