part of 'cart_bloc.dart';

class CartState extends Equatable {
  final Map<String, CartItem> items;
  final bool isLoading;
  final String? error;
  final DateTime lastUpdated;

  CartState({
    this.items = const {},
    this.isLoading = false,
    this.error,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  int get totalQuantity =>
      items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice {
    return items.values
        .fold(0, (sum, item) => sum + (item.price! * item.quantity));
  }

  factory CartState.initial() => CartState();

  CartState copyWith({
    Map<String, CartItem>? items,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, int> get quantityPerProductId {
    final result = <String, int>{};
    for (final item in items.values) {
      final productId = item.variation.productId;
      if (productId != null) {
        result[productId] = (result[productId] ?? 0) + item.quantity;
      }
    }
    return result;
  }

  @override
  List<Object?> get props => [items, isLoading, error, lastUpdated];
}
