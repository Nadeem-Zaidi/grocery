import '../product/productt.dart';

class CartItem {
  final Variation variation;
  final int quantity;
  final double? price;

  final DateTime updatedAt;

  CartItem({
    required this.variation,
    this.price,
    this.quantity = 1,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  CartItem copyWith({
    Variation? variation,
    int? quantity,
    double? price,
    DateTime? updatedAt,
  }) {
    return CartItem(
      variation: variation ?? this.variation,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'variation': variation.toMap(),
        'quantity': quantity,
        'price': price,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory CartItem.fromMap(Map<String, dynamic> map) => CartItem(
        variation: Variation.fromMap(map['variation']),
        quantity: map['quantity'],
        price: map['price']?.toDouble(),
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

  Map<String, int> get quantityPerProductId {
    final Map<String, int> result = {};
    for (final item in items.values) {
      final productId = item.variation.productId;
      if (productId == null) continue; // ✅ skip if null

      result[productId] = (result[productId] ?? 0) + item.quantity;
    }
    return result;
  }

  /// ✅ Count of unique product IDs
  int get uniqueProductIdsCount {
    final productIds = items.values.map((e) => e.variation.productId).toSet();
    return productIds.length;
  }

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
