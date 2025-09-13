import 'package:grocery_app/database_service.dart/model_registry.dart';
import 'package:grocery_app/models/category.dart';

import '../../models/product/productt.dart';

sealed class Section<T> {
  final String? id;
  final String name;
  final String type;
  final List<String> imageUrls;
  final List<T> content;
  final String? heading;
  final String? subheading;
  final String? description;
  final int sequence;

  Section({
    this.id,
    required this.name,
    required this.type,
    required this.sequence,
    this.imageUrls = const [],
    this.content = const [],
    this.heading,
    this.subheading,
    this.description,
  });

  Map<String, dynamic> toBaseMap() => {
        'id': id,
        'name': name,
        'type': type,
        'sequence': sequence,
        'imageurls': imageUrls,
        'heading': heading,
        'subheading': subheading,
        'description': description,
      };

  Map<String, dynamic> toMap();

  static Section fromMap(Map<String, dynamic> map) {
    switch (map['type']) {
      case "category":
        return CategorySection.fromMap(map);
      case "product":
        return ProductSpotlightSection.fromMap(map);
      default:
        throw Exception("Unknown Section type: ${map['type']}");
    }
  }

  /// Generic copyWith at the base class (delegates to subclass copyWith)
  Section<T> copyWith({
    String? id,
    String? name,
    String? type,
    int? sequence,
    List<String>? imageUrls,
    List<T>? content,
    String? heading,
    String? subheading,
    String? description,
  });
}

class CategorySection extends Section<Category> {
  CategorySection({
    required super.id,
    required super.name,
    required super.type,
    required super.sequence,
    super.imageUrls,
    super.content,
    super.heading,
    super.subheading,
    super.description,
  });

  factory CategorySection.fromMap(Map<String, dynamic> map) {
    return CategorySection(
      id: map['id'] as String?,
      name: map['name'] as String,
      type: map['type'] as String,
      sequence: map['sequence'] as int,
      imageUrls: List<String>.from(map['imageurls'] ?? []),
      heading: map['heading'] as String?,
      subheading: map['subheading'] as String?,
      description: map['description'] as String?,
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
    String? heading,
    String? subheading,
    String? description,
  }) {
    return CategorySection(
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

class ProductSpotlightSection extends Section<Productt> {
  ProductSpotlightSection({
    required super.id,
    required super.name,
    required super.type,
    required super.sequence,
    super.imageUrls,
    super.content,
    super.heading,
    super.subheading,
    super.description,
  });

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
