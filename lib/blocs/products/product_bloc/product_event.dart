part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class AddProductEvent extends ProductEvent {}

class FetchProductEvent extends ProductEvent {}
