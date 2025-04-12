class Cart {
  final Map<String, int> cartItems;

  Cart({required this.cartItems});

  factory Cart.fromMap(Map<String, dynamic> data) {
    final items = Map<String, int>.from(data['cartItems'] ?? {});
    return Cart(cartItems: items);
  }

  int get totalQuantity =>
      cartItems.values.fold(0, (sum, itemQty) => sum + itemQty);

  double get totalPrice {
    // You'll need product data to calculate this
    return 0;
  }

  double get discount => 0; // You can enhance this later
}
