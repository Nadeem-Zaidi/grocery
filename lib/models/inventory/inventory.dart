import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Inventory {
  final String? id;
  final String? productId;
  final String? sku;
  final String? unit;
  final int? quantityInBox;
  final int? quantityAvailable;
  final double? mrp;
  final double? sellingPrice;
  final double? discount;

  Inventory({
    this.id,
    this.productId,
    this.sku,
    this.unit,
    this.quantityInBox,
    this.quantityAvailable,
    this.mrp,
    this.sellingPrice,
    this.discount,
  });

  // Copy with new values (nullable fields)
  Inventory copyWith({
    String? id,
    String? productId,
    String? sku,
    String? unit,
    int? quantityInBox,
    int? quantityAvailable,
    double? mrp,
    double? sellingPrice,
    double? discount,
  }) {
    return Inventory(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      sku: sku ?? this.sku,
      unit: unit ?? this.unit,
      quantityInBox: quantityInBox ?? this.quantityInBox,
      quantityAvailable: quantityAvailable ?? this.quantityAvailable,
      mrp: mrp ?? this.mrp,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      discount: discount ?? this.discount,
    );
  }

  // Convert to Map (handles nulls)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'sku': sku,
      'unit': unit,
      'quantityInBox': quantityInBox,
      'quantityAvailable': quantityAvailable,
      'mrp': mrp,
      'sellingPrice': sellingPrice,
      'discount': discount,
    }..removeWhere(
        (key, value) => value == null); // Optional: remove null fields
  }

  // Create from Map (with null safety)
  factory Inventory.fromMap(Map<String, dynamic> map) {
    return Inventory(
      id: map['id']?.toString(),
      productId: map['productId']?.toString(),
      sku: map['sku']?.toString(),
      unit: map['unit']?.toString(),
      quantityInBox: map['quantityInBox'] != null
          ? int.tryParse(map['quantityInBox'].toString())
          : null,
      quantityAvailable: map['quantityAvailable'] != null
          ? int.tryParse(map['quantityAvailable'].toString())
          : null,
      mrp: map['mrp'] != null ? double.tryParse(map['mrp'].toString()) : null,
      sellingPrice: map['sellingPrice'] != null
          ? double.tryParse(map['sellingPrice'].toString())
          : null,
      discount: map['discount'] != null
          ? double.tryParse(map['discount'].toString())
          : null,
    );
  }

  factory Inventory.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>? ?? {};
    return Inventory.fromMap(map).copyWith(id: doc.id);
  }

  String toJson() => json.encode(toMap());
  factory Inventory.fromJson(String source) =>
      Inventory.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Inventory &&
        other.id == id &&
        other.productId == productId &&
        other.sku == sku &&
        other.unit == unit &&
        other.quantityInBox == quantityInBox &&
        other.quantityAvailable == quantityAvailable &&
        other.mrp == mrp &&
        other.sellingPrice == sellingPrice &&
        other.discount == discount;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      productId,
      sku,
      unit,
      quantityInBox,
      quantityAvailable,
      mrp,
      sellingPrice,
      discount,
    );
  }

  @override
  String toString() {
    return 'Inventory('
        'id: $id, '
        'productId: $productId, '
        'sku: $sku, '
        'unit: $unit, '
        'quantityInBox: $quantityInBox, '
        'quantityAvailable: $quantityAvailable, '
        'mrp: $mrp, '
        'sellingPrice: $sellingPrice, '
        'discount: $discount)';
  }
}
