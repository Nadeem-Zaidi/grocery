import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Product {
  final String id;
  final String name;
  final String brand;
  final String user;
  final String category;
  final List<String> images;
  final List<String> description;
  final List<String> tags;

  /// Constructor
  const Product({
    this.id = "",
    this.name = "",
    this.brand = "",
    this.user = "",
    this.category = "",
    this.images = const [],
    this.description = const [],
    this.tags = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "brand": brand,
      "user": user,
      "category": category,
      "images": images,
      "description": description,
      "tags": tags,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map["id"] ?? "",
      name: map["name"] ?? "",
      brand: map["brand"] ?? "",
      user: map["user"] ?? "",
      category: map["category"] ?? "",
      images: List<String>.from(map["images"] ?? []),
      description: List<String>.from(map["description"] ?? []),
      tags: List<String>.from(map["tags"] ?? []),
    );
  }

  Product copyWith({
    String? id,
    String? name,
    String? brand,
    String? user,
    String? category,
    List<String>? images,
    List<String>? description,
    List<String>? tags,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      user: user ?? this.user,
      category: category ?? this.category,
      images: images ?? List.from(this.images), // Deep copy
      description: description ?? List.from(this.description),
      tags: tags ?? List.from(this.tags),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.brand == brand &&
        other.user == user &&
        other.category == category &&
        ListEquality().equals(other.images, images) &&
        ListEquality().equals(other.description, description) &&
        ListEquality().equals(other.tags, tags);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      brand,
      user,
      category,
      Object.hashAll(images),
      Object.hashAll(description),
      Object.hashAll(tags),
    );
  }

  @override
  String toString() {
    return "Product(id: $id, name: $name, brand: $brand, user: $user, category: $category, images: $images, description: $description, tags: $tags)";
  }
}
