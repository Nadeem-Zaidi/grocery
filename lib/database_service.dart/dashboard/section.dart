import 'package:grocery_app/database_service.dart/model_registry.dart';
import 'package:grocery_app/models/category.dart';
import 'package:grocery_app/models/custom_cards/customcard.dart';

import '../../models/product/productt.dart';

abstract class Section<T> {
  final String? id;
  final String type;
  final String name;
  final List<String> imageUrls;
  final List<T> content;
  final int sequence;
  final Map<String, String> attributes;

  Section({
    this.id,
    required this.type,
    required this.sequence,
    required this.name,
    this.imageUrls = const [],
    this.content = const [],
    this.attributes = const {},
  });

  Map<String, dynamic> toBaseMap() => {
        'id': id,
        'type': type,
        'name': name,
        'sequence': sequence,
        'imageurls': imageUrls,
        'attributes': attributes
      };

  Map<String, dynamic> toMap();

  static Section fromMap(Map<String, dynamic> map) {
    switch (map['type']) {
      case "category":
        return CategorySection.fromMap(map);
      case "product":
        return ProductSpotlightSection.fromMap(map);
      case "promotion":
        return AppbarPromotionSection.fromMap(map);
      default:
        throw Exception("Unknown Section type: ${map['type']}");
    }
  }

  Section<T> copyWith(
      {String? id,
      String? type,
      int? sequence,
      String? name,
      List<String>? imageUrls,
      List<T>? content,
      Map<String, String>? attributes});
}

/// CATEGORY
class CategorySection extends Section<Category> {
  CategorySection({
    required super.id,
    required super.type,
    required super.name,
    required super.sequence,
    super.attributes,
    super.imageUrls,
    super.content,
  });

  factory CategorySection.initial() => CategorySection(
        id: "NEW-${DateTime.now().millisecondsSinceEpoch}",
        type: "category",
        name: "",
        sequence: 0,
        imageUrls: [],
        content: [],
        attributes: {},
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
      attributes: Map<String, String>.from(
          map['attributes'] as Map? ?? <String, String>{}),
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
    Map<String, String>? attributes,
  }) {
    return CategorySection(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        sequence: sequence ?? this.sequence,
        imageUrls: imageUrls ?? this.imageUrls,
        content: content ?? this.content,
        attributes: attributes ?? this.attributes);
  }
}

/// PRODUCT SPOTLIGHT
class ProductSpotlightSection extends Section<Productt> {
  ProductSpotlightSection({
    required super.id,
    required super.name,
    required super.type,
    required super.sequence,
    super.imageUrls,
    super.attributes,
    super.content,
  });

  factory ProductSpotlightSection.initial() => ProductSpotlightSection(
        id: "NEW-${DateTime.now().millisecondsSinceEpoch}",
        name: "",
        type: "product",
        sequence: 0,
        imageUrls: [],
        content: [],
        attributes: {},
      );

  factory ProductSpotlightSection.fromMap(Map<String, dynamic> map) {
    return ProductSpotlightSection(
        id: map['id'] as String?,
        name: map['name'] as String,
        type: map['type'] as String,
        sequence: map['sequence'] as int,
        imageUrls: List<String>.from(map['imageUrls'] ?? []),
        content: (map['content'] as List<dynamic>? ?? [])
            .map((e) => Productt.fromMap(e as Map<String, dynamic>))
            .toList(),
        attributes: Map<String, String>.from(
            map['attributes'] as Map? ?? <String, String>{}));
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
    Map<String, String>? attributes,
  }) {
    return ProductSpotlightSection(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        sequence: sequence ?? this.sequence,
        imageUrls: imageUrls ?? this.imageUrls,
        content: content ?? this.content,
        attributes: attributes ?? this.attributes);
  }
}

class AppbarPromotionSection extends Section<PlainCard> {
  AppbarPromotionSection({
    required super.id,
    required super.type,
    required super.sequence,
    required super.name,
    super.imageUrls,
    required super.content,
    super.attributes = const {},
  });

  factory AppbarPromotionSection.initial() => AppbarPromotionSection(
        id: "NEW-${DateTime.now().millisecondsSinceEpoch}",
        type: "promotion",
        name: "",
        sequence: 0,
        imageUrls: [],
        content: [],
        attributes: {},
      );

  factory AppbarPromotionSection.fromMap(Map<String, dynamic> map) {
    return AppbarPromotionSection(
      id: map['id'] as String?,
      type: map['type'] as String,
      name: map['name'] as String,
      sequence: map['sequence'] as int,
      imageUrls: List<String>.from(map['imageurls'] ?? []),
      content: map['content'] ?? [],
      attributes: Map<String, String>.from(
        map['attributes'] as Map? ?? <String, String>{},
      ),
    );
  }

  @override
  AppbarPromotionSection copyWith({
    String? id,
    String? type,
    int? sequence,
    String? name,
    List<String>? imageUrls,
    List<PlainCard>? content,
    Map<String, String>? attributes,
  }) {
    return AppbarPromotionSection(
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
        'content': content.map((item) => item.toMap()).toList(),
      };
}

class AppbarPromotionSectionGridView extends Section {
  AppbarPromotionSectionGridView({
    required super.id,
    required super.type,
    required super.sequence,
    required super.name,
    super.imageUrls,
    required super.content,
    super.attributes = const {},
  });

  factory AppbarPromotionSectionGridView.initial() =>
      AppbarPromotionSectionGridView(
        id: "NEW-${DateTime.now().millisecondsSinceEpoch}",
        type: "promogridview",
        name: "",
        sequence: 0,
        imageUrls: [],
        content: [],
        attributes: {},
      );

  @override
  Section copyWith({
    String? id,
    String? type,
    int? sequence,
    String? name,
    List<String>? imageUrls,
    List? content,
    Map<String, String>? attributes,
  }) {
    return AppbarPromotionSectionGridView(
      id: id ?? this.id,
      type: type ?? this.type,
      sequence: sequence ?? this.sequence,
      name: name ?? this.name,
      imageUrls: imageUrls ?? this.imageUrls,
      content: content ?? this.content,
      attributes: attributes ?? this.attributes,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        ...toBaseMap(),
        'attributes': attributes,
        'content': content.map((item) => item.toMap()).toList(),
      };
}
