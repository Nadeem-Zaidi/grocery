import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? id;
  final String? name;
  final String? brand;
  final String? user;
  final String? category;
  final String? summary;
  final List<String> images;
  final List<String> description;
  final String? keyFeatures;
  final List<String> tags;
  final bool isVariation;
  final String? unit;
  final int? quantityInBox;
  final int? quantityAvailable;
  final double? mrp;
  final double? sellingPrice;
  final double? discount;
  final String? manufacturer;
  //
  final String? fssaiLicense;
  final String? shelfLife;
  final String? type;
  final String? countryOfOrigin;
  final String? customerCareDet;
  final String? seller;
  final String? disclaimer;

  const Product({
    this.id,
    this.name,
    this.brand,
    this.user,
    this.category,
    this.summary,
    this.keyFeatures,
    List<String>? images,
    List<String>? description,
    List<String>? tags,
    this.isVariation = false,
    this.unit,
    this.quantityInBox,
    this.quantityAvailable,
    this.mrp,
    this.sellingPrice,
    this.discount,
    this.manufacturer,
    this.fssaiLicense,
    this.shelfLife,
    this.type,
    this.countryOfOrigin, 
    this.customerCareDet,
    this.seller,
    this.disclaimer,
  })  : images = images ?? const [],
        description = description ?? const [],
        tags = tags ?? const [];

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Product.fromMap(data).copyWith(id: doc.id);
  }

  factory Product.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const Product();

    return Product(
      id: map['id']?.toString(),
      name: map['name']?.toString(),
      brand: map['brand']?.toString(),
      user: map['user']?.toString(),
      category: map['category']?.toString(),
      summary: map['summary']?.toString(),
      keyFeatures: map['keyFeatures']?.toString(),
      images: (map['images'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      description:
          (map['description'] as List?)?.map((e) => e.toString()).toList() ??
              const [],
      tags:
          (map['tags'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      isVariation: map['isVariation'] as bool? ?? false,
      unit: map['unit']?.toString(),
      quantityInBox: map['quantityInBox'] as int?,
      quantityAvailable: map['quantityAvailable'] as int?,
      mrp: map['mrp']?.toDouble(),
      sellingPrice: map['sellingPrice']?.toDouble(),
      discount: map['discount']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (user != null) 'user': user,
      if (category != null) 'category': category,
      if (summary != null) 'summary': summary,
      if (keyFeatures != null) 'keyFeatures': keyFeatures,
      'images': images,
      'description': description,
      'tags': tags,
      'isVariation': isVariation,
      if (unit != null) 'unit': unit,
      if (quantityInBox != null) 'quantityInBox': quantityInBox,
      if (quantityAvailable != null) 'quantityAvailable': quantityAvailable,
      if (mrp != null) 'mrp': mrp,
      if (sellingPrice != null) 'sellingPrice': sellingPrice,
      if (discount != null) 'discount': discount,
    }..removeWhere((key, value) => value == null);
  }

  Product copyWith({
    String? id,
    String? name,
    String? brand,
    String? user,
    String? category,
    String? summary,
    String? keyFeatures,
    List<String>? images,
    List<String>? description,
    List<String>? tags,
    bool? isVariation,
    String? unit,
    int? quantityInBox,
    int? quantityAvailable,
    double? mrp,
    double? sellingPrice,
    double? discount,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      user: user ?? this.user,
      category: category ?? this.category,
      summary: summary ?? this.summary,
      keyFeatures: keyFeatures ?? this.keyFeatures,
      images: images ?? this.images,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      isVariation: isVariation ?? this.isVariation,
      unit: unit ?? this.unit,
      quantityInBox: quantityInBox ?? this.quantityInBox,
      quantityAvailable: quantityAvailable ?? this.quantityAvailable,
      mrp: mrp ?? this.mrp,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      discount: discount ?? this.discount,
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
        other.summary == summary &&
        other.keyFeatures == keyFeatures &&
        other.isVariation == isVariation &&
        const ListEquality<String>().equals(other.images, images) &&
        const ListEquality<String>().equals(other.description, description) &&
        const ListEquality<String>().equals(other.tags, tags) &&
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
      name,
      brand,
      user,
      category,
      summary,
      keyFeatures,
      isVariation,
      const ListEquality<String>().hash(images),
      const ListEquality<String>().hash(description),
      const ListEquality<String>().hash(tags),
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
    return 'Product('
        'id: $id, '
        'name: $name, '
        'brand: $brand, '
        'user: $user, '
        'category: $category, '
        'summary: $summary, '
        'keyFeatures: $keyFeatures, '
        'isVariation: $isVariation, '
        'images: $images, '
        'description: $description, '
        'tags: $tags, '
        'unit: $unit, '
        'quantityInBox: $quantityInBox, '
        'quantityAvailable: $quantityAvailable, '
        'mrp: $mrp, '
        'sellingPrice: $sellingPrice, '
        'discount: $discount)';
  }

  static List<String>? validate(Product product,
      {List<String> requiredFields = const ['name', 'brand', 'category']}) {
    final errors = <String>[];

    if (requiredFields.contains('name') &&
        (product.name == null || product.name!.isEmpty)) {
      errors.add('Name is required');
    }
    if (requiredFields.contains('brand') &&
        (product.brand == null || product.brand!.isEmpty)) {
      errors.add('Brand is required');
    }
    if (requiredFields.contains('category') &&
        (product.category == null || product.category!.isEmpty)) {
      errors.add('Category is required');
    }

    return errors.isEmpty ? null : errors;
  }
}
