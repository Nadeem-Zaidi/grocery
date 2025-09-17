import 'package:grocery_app/database_service.dart/model_registry.dart';
import 'package:grocery_app/models/category.dart';

import '../../models/product/productt.dart';

sealed class Section<T> {
  final String? id;
  final String type;
  final String name;
  final List<String> imageUrls;
  final List<T> content;
  final int sequence;

  Section({
    this.id,
    required this.type,
    required this.sequence,
    required this.name,
    this.imageUrls = const [],
    this.content = const [],
  });

  Map<String, dynamic> toBaseMap() => {
        'id': id,
        'type': type,
        'name': name,
        'sequence': sequence,
        'imageurls': imageUrls,
      };

  Map<String, dynamic> toMap();

  static Section fromMap(Map<String, dynamic> map) {
    switch (map['type']) {
      case "category":
        return CategorySection.fromMap(map);
      case "product":
        return ProductSpotlightSection.fromMap(map);
      case "promotion":
        return PromotionSection.fromMap(map);
      default:
        throw Exception("Unknown Section type: ${map['type']}");
    }
  }

  Section<T> copyWith({
    String? id,
    String? type,
    int? sequence,
    String? name,
    List<String>? imageUrls,
    List<T>? content,
  });
}

/// CATEGORY
class CategorySection extends Section<Category> {
  CategorySection({
    required super.id,
    required super.type,
    required super.name,
    required super.sequence,
    super.imageUrls,
    super.content,
  });

  /// 👇 factory initial
  factory CategorySection.initial() => CategorySection(
        id: null,
        type: "category",
        name: "",
        sequence: 0,
        imageUrls: [],
        content: [],
      );

  factory CategorySection.fromMap(Map<String, dynamic> map) {
    return CategorySection(
      id: map['id'] as String?,
      name: map['name'] as String,
      type: map['type'] as String,
      sequence: map['sequence'] as int,
      imageUrls: List<String>.from(map['imageurls'] ?? []),
      content: (map['content'] as List<dynamic>? ?? [])
          .map(
              (e) => ModelRegistry.fromMap<Category>(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        ...toBaseMap(),
        'content': content.map((e) => e.toMap()).toList(),
      };

  @override
  CategorySection copyWith({
    String? id,
    String? name,
    String? type,
    int? sequence,
    List<String>? imageUrls,
    List<Category>? content,
  }) {
    return CategorySection(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      sequence: sequence ?? this.sequence,
      imageUrls: imageUrls ?? this.imageUrls,
      content: content ?? this.content,
    );
  }
}

/// PRODUCT SPOTLIGHT
class ProductSpotlightSection extends Section<Productt> {
  String? heading;
  String? subheading;
  String? description;

  ProductSpotlightSection({
    required super.id,
    required super.name,
    required super.type,
    required super.sequence,
    super.imageUrls,
    super.content,
    this.heading,
    this.subheading,
    this.description,
  });

  /// 👇 factory initial
  factory ProductSpotlightSection.initial() => ProductSpotlightSection(
        id: null,
        name: "",
        type: "product",
        sequence: 0,
        imageUrls: [],
        content: [],
        heading: null,
        subheading: null,
        description: null,
      );

  factory ProductSpotlightSection.fromMap(Map<String, dynamic> map) {
    return ProductSpotlightSection(
      id: map['id'] as String?,
      name: map['name'] as String,
      type: map['type'] as String,
      sequence: map['sequence'] as int,
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      heading: map['heading'] as String?,
      subheading: map['subheading'] as String?,
      description: map['description'] as String?,
      content: (map['content'] as List<dynamic>? ?? [])
          .map((e) => Productt.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        ...toBaseMap(),
        'content': content.map((e) => e.toMap()).toList(),
      };

  @override
  ProductSpotlightSection copyWith({
    String? id,
    String? name,
    String? type,
    int? sequence,
    List<String>? imageUrls,
    List<Productt>? content,
    String? heading,
    String? subheading,
    String? description,
  }) {
    return ProductSpotlightSection(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      sequence: sequence ?? this.sequence,
      imageUrls: imageUrls ?? this.imageUrls,
      content: content ?? this.content,
      heading: heading ?? this.heading,
      subheading: subheading ?? this.subheading,
      description: description ?? this.description,
    );
  }
}

/// PROMOTION
class PromotionSection extends Section {
  Map<String, String> attributes;

  PromotionSection({
    required super.id,
    required super.type,
    required super.sequence,
    required super.name,
    required super.imageUrls,
    required super.content,
    this.attributes = const {},
  });

  /// 👇 factory initial
  factory PromotionSection.initial() => PromotionSection(
        id: null,
        type: "promotion",
        name: "",
        sequence: 0,
        imageUrls: [],
        content: [],
        attributes: {},
      );

  factory PromotionSection.fromMap(Map<String, dynamic> map) {
    return PromotionSection(
      id: map['id'] as String?,
      type: map['type'] as String,
      name: map['name'] as String,
      sequence: map['sequence'] as int,
      imageUrls: List<String>.from(map['imageurls'] ?? []),
      content: map['content'] ?? [],
      attributes: Map<String, String>.from(
          map['attributes'] as Map? ?? <String, String>{}),
    );
  }

  @override
  PromotionSection copyWith({
    String? id,
    String? type,
    int? sequence,
    String? name,
    List<String>? imageUrls,
    List? content,
    Map<String, String>? attributes,
  }) {
    return PromotionSection(
      id: id ?? this.id,
      type: type ?? this.type,
      sequence: sequence ?? this.sequence,
      name: name ?? this.name,
      attributes: attributes ?? this.attributes,
      imageUrls: imageUrls ?? this.imageUrls,
      content: content ?? this.content,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        ...toBaseMap(),
        'attributes': attributes,
        'content': content,
      };
}
