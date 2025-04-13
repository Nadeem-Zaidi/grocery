class CartItem {
  final String productId;
  final int quantity;
  final double? price;
  final DateTime updatedAt;

  CartItem({
    required this.productId,
    this.price,
    this.quantity = 1,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  CartItem copyWith({
    String? productId,
    int? quantity,
    double? price,
    DateTime? updatedAt,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'quantity': quantity,
        'price': price,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory CartItem.fromMap(Map<String, dynamic> map) => CartItem(
        productId: map['productId'],
        quantity: map['quantity'],
        price: map['price']?.toDouble() ?? 0.0,
        updatedAt: DateTime.parse(map['updatedAt']),
      );
}

class Cart {
  final Map<String, CartItem> items;
  final String? userId;
  final DateTime lastLocalUpdate;
  Cart({
    Map<String, CartItem>? items,
    this.userId,
    DateTime? lastLocalUpdate,
  })  : items = items ?? const {},
        lastLocalUpdate = lastLocalUpdate ?? DateTime.now();

  Cart copyWith({
    Map<String, CartItem>? items,
    String? userId,
    DateTime? lastLocalUpdate,
  }) {
    return Cart(
      items: items ?? this.items,
      userId: userId ?? this.userId,
      lastLocalUpdate: lastLocalUpdate ?? this.lastLocalUpdate,
    );
  }
}
