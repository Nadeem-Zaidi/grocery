part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartInitRequested extends CartEvent {}

class CartItemAdded extends CartEvent {
  final Variation variation;
  final int quantity;

  const CartItemAdded({
    required this.variation,
    this.quantity = 1,
  });

  @override
  List<Object> get props => [variation, quantity];
}

class CartItemRemoved extends CartEvent {
  final String productId;

  const CartItemRemoved(this.productId);

  @override
  List<Object> get props => [productId];
}

class CartCleared extends CartEvent {}

class CartSyncRequested extends CartEvent {}
