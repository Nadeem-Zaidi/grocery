import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Product {
  final String? id;
  final String? name;
  final String? brand;
  final String? user;
  final String? category;
  final List<String> images;
  final List<String> description;
  final List<String> tags;
  final bool isVariation;

  /// Main constructor with optional nullable fields
  const Product({
    this.id,
    this.name,
    this.brand,
    this.user,
    this.category,
    List<String>? images,
    List<String>? description,
    List<String>? tags,
    this.isVariation = false,
  })  : images = images ?? const [],
        description = description ?? const [],
        tags = tags ?? const [];

  /// Empty product constructor
  const Product.empty()
      : id = null,
        name = null,
        brand = null,
        user = null,
        category = null,
        images = const [],
        description = const [],
        tags = const [],
        isVariation = false;

  /// Factory constructor from map with null safety
  factory Product.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const Product.empty();

    return Product(
      id: map['id']?.toString(),
      name: map['name']?.toString(),
      brand: map['brand']?.toString(),
      user: map['user']?.toString(),
      category: map['category']?.toString(),
      images: (map['images'] as List?)?.map((e) => e.toString()).toList(),
      description:
          (map['description'] as List?)?.map((e) => e.toString()).toList(),
      tags: (map['tags'] as List?)?.map((e) => e.toString()).toList(),
      isVariation: map['isVariation'] as bool? ?? false,
    );
  }

  /// Converts product to map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (user != null) 'user': user,
      if (category != null) 'category': category,
      'images': images,
      'description': description,
      'tags': tags,
      'isVariation': isVariation,
    };
  }

  /// Creates a copy with updated fields
  Product copyWith({
    String? id,
    String? name,
    String? brand,
    String? user,
    String? category,
    List<String>? images,
    List<String>? description,
    List<String>? tags,
    bool? isVariation,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      user: user ?? this.user,
      category: category ?? this.category,
      images: images ?? this.images,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      isVariation: isVariation ?? this.isVariation,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.brand == brand &&
        other.user == user &&
        other.category == category &&
        other.isVariation == isVariation &&
        const ListEquality<String>().equals(other.images, images) &&
        const ListEquality<String>().equals(other.description, description) &&
        const ListEquality<String>().equals(other.tags, tags);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      brand,
      user,
      category,
      isVariation,
      const ListEquality<String>().hash(images),
      const ListEquality<String>().hash(description),
      const ListEquality<String>().hash(tags),
    );
  }

  @override
  String toString() {
    return 'Product('
        'id: $id, '
        'name: $name, '
        'brand: $brand, '
        'user: $user, '
        'category: $category, '
        'isVariation: $isVariation, '
        'images: $images, '
        'description: $description, '
        'tags: $tags)';
  }

  /// Validation method
  static List<String>? validate(Product product,
      {List<String> requiredFields = const []}) {
    final errors = <String>[];

    if (requiredFields.contains('name') && product.name == null) {
      errors.add('Name is required');
    }
    if (requiredFields.contains('brand') && product.brand == null) {
      errors.add('Brand is required');
    }
    if (requiredFields.contains('category') && product.category == null) {
      errors.add('Category is required');
    }

    return errors.isEmpty ? null : errors;
  }
}
