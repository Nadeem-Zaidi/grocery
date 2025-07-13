import 'package:flutter/material.dart';
import 'package:grocery_app/database_service.dart/ientity.dart';
import 'package:grocery_app/database_service.dart/model_registry.dart';
import 'dart:collection';

import 'package:grocery_app/models/product/product.dart';

class Inventory implements IEntity<Inventory> {
  final String? id;
  final String unitOfMeasure; // unitofmeasure
  final String unitSize; // unitsize
  final String packs; // packs
  final double mrp;
  final double discount;
  final double sellingPrice;
  final int stockInHand;
  final String? lengthWithoutPkg;
  final String? heightWithoutPkg;
  final String status;
  final String? reorderPoint;

  Inventory({
    this.id,
    required this.unitOfMeasure,
    required this.unitSize,
    required this.packs,
    required this.mrp,
    required this.discount,
    required this.sellingPrice,
    required this.stockInHand,
    this.lengthWithoutPkg,
    this.heightWithoutPkg,
    required this.status,
    this.reorderPoint,
  });

  factory Inventory.fromMap(Map<String, dynamic> map) {
    double parseDouble(dynamic value, String fieldName) {
      if (value == null) {
        throw FormatException('Missing required field: $fieldName');
      }
      if (value is num) return value.toDouble();
      if (value is String) {
        final parsed = double.tryParse(value);
        if (parsed == null) {
          throw FormatException('Invalid double for $fieldName: $value');
        }
        return parsed;
      }
      throw FormatException(
          'Invalid type for $fieldName: ${value.runtimeType}');
    }

    int parseInt(dynamic value, String fieldName) {
      if (value == null) {
        throw FormatException('Missing required field: $fieldName');
      }
      if (value is num) return value.toInt();
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed == null) {
          throw FormatException('Invalid int for $fieldName: $value');
        }
        return parsed;
      }
      throw FormatException(
          'Invalid type for $fieldName: ${value.runtimeType}');
    }

    return Inventory(
      id: map['id']?.toString(),
      unitOfMeasure: map["unitofmeasure"] ?? '',
      unitSize: map["unitsize"] ?? '',
      packs: map["packs"] ?? '',
      mrp: parseDouble(map['mrp'], 'mrp'),
      discount: parseDouble(map['discount'], 'discount'),
      sellingPrice: parseDouble(map['sellingprice'], 'sellingprice'),
      stockInHand: parseInt(map['stockinhand'], 'stockinhand'),
      lengthWithoutPkg: map["lengthwithoutpkg"]?.toString(),
      heightWithoutPkg: map["heightwithoutpkg"]?.toString(),
      status: map["status"] ?? '',
      reorderPoint: map["reorderpoint"]?.toString(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "unitofmeasure": unitOfMeasure,
      "unitsize": unitSize,
      "packs": packs,
      "mrp": mrp,
      "discount": discount,
      "sellingprice": sellingPrice,
      "stockinhand": stockInHand,
      "lengthwithoutpkg": lengthWithoutPkg,
      "heightwithoutpkg": heightWithoutPkg,
      "status": status,
      "reorderpoint": reorderPoint,
    };
  }

  @override
  Inventory copyWith({
    String? id,
    String? unitOfMeasure,
    String? unitSize,
    String? packs,
    double? mrp,
    double? discount,
    double? sellingPrice,
    int? stockInHand,
    String? lengthWithoutPkg,
    String? heightWithoutPkg,
    String? status,
    String? reorderPoint,
  }) {
    return Inventory(
      id: id ?? this.id,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      unitSize: unitSize ?? this.unitSize,
      packs: packs ?? this.packs,
      mrp: mrp ?? this.mrp,
      discount: discount ?? this.discount,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      stockInHand: stockInHand ?? this.stockInHand,
      lengthWithoutPkg: lengthWithoutPkg ?? this.lengthWithoutPkg,
      heightWithoutPkg: heightWithoutPkg ?? this.heightWithoutPkg,
      status: status ?? this.status,
      reorderPoint: reorderPoint ?? this.reorderPoint,
    );
  }
}

class Variation implements IEntity<Variation> {
  final String? id;
  final String? productId;
  final String name; // variationname
  final String description; // vdescription
  final String unitOfMeasure; // unitofmeasure
  final String unitSize; // unitsize
  final String packs; // packs
  final double mrp;
  final double discount;
  final double sellingPrice;
  final int stockInHand;
  final String sellerInformation; // seller
  final String? lengthWithoutPkg;
  final String? heightWithoutPkg;
  final String status; // Status
  final String? reorderPoint;
  final List<String> images; // images
  final String? shelfLife;
  final String? attaType;
  final String? ingredients;
  final Map<String, dynamic> highLights;
  final Map<String, dynamic> info;

  Variation(
      {this.id,
      required this.name,
      required this.productId,
      required this.description,
      required this.unitOfMeasure,
      required this.unitSize,
      this.packs = "1",
      required this.mrp,
      required this.discount,
      required this.sellingPrice,
      required this.stockInHand,
      required this.sellerInformation,
      this.lengthWithoutPkg,
      this.heightWithoutPkg,
      required this.status,
      this.reorderPoint,
      this.images = const [],
      this.shelfLife,
      this.attaType,
      this.ingredients,
      this.highLights = const {},
      this.info = const {}});

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "productid": productId,
      "variationname": name,
      "vdescription": description,
      "unitofmeasure": unitOfMeasure,
      "unitsize": unitSize,
      "packs": packs,
      "mrp": mrp,
      "discount": discount,
      "sellingprice": sellingPrice,
      "stockinhand": stockInHand,
      "seller": sellerInformation,
      "lengthwithoutpkg": lengthWithoutPkg,
      "heightwithoutpkg": heightWithoutPkg,
      "status": status,
      "reorderpoint": reorderPoint,
      "images": images,
      "shelflife": shelfLife,
      "attatype": attaType,
      "ingredients": ingredients,
      "highlights": highLights,
      "info": info
    };
  }

  factory Variation.fromMap(Map<String, dynamic> map) {
    return Variation(
      id: map["id"],
      productId: map["productid"],
      name: map["variationname"] ?? '',
      description: map["vdescription"] ?? '',
      unitOfMeasure: map["unitofmeasure"] ?? '',
      unitSize: map["unitsize"] ?? '',
      packs: map["packs"] ?? '',
      mrp: double.tryParse(map["mrp"].toString()) ?? 0.0,
      discount: double.tryParse(map["discount"].toString()) ?? 0.0,
      sellingPrice: double.tryParse(map["sellingprice"].toString()) ?? 0.0,
      stockInHand: int.tryParse("stockinhand") ?? 0,
      sellerInformation: map["seller"] ?? '',
      lengthWithoutPkg: map["lengthwithoutpkg"],
      heightWithoutPkg: map["heightwithoutpkg"],
      status: map["status"] ?? '',
      reorderPoint: map["reorderpoint"],
      images: List<String>.from(map["images"] ?? []),
      shelfLife: map["shelflife"],
      attaType: map["attatype"],
      ingredients: map["ingredients"],
      highLights: map["highlights"] ?? {},
      info: map["info"] ?? {},
    );
  }

  @override
  Variation copyWith({
    String? id,
    String? productId,
    String? name,
    String? description,
    String? unitOfMeasure,
    String? unitSize,
    String? packs,
    double? mrp,
    double? discount,
    double? sellingPrice,
    int? stockInHand,
    String? sellerInformation,
    String? lengthWithoutPkg,
    String? heightWithoutPkg,
    String? status,
    String? reorderPoint,
    List<String>? images,
    String? shelfLife,
    String? attaType,
    String? ingredients,
  }) {
    return Variation(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      description: description ?? this.description,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      unitSize: unitSize ?? this.unitSize,
      packs: packs ?? this.packs,
      mrp: mrp ?? this.mrp,
      discount: discount ?? this.discount,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      stockInHand: stockInHand ?? this.stockInHand,
      sellerInformation: sellerInformation ?? this.sellerInformation,
      lengthWithoutPkg: lengthWithoutPkg ?? this.lengthWithoutPkg,
      heightWithoutPkg: heightWithoutPkg ?? this.heightWithoutPkg,
      status: status ?? this.status,
      reorderPoint: reorderPoint ?? this.reorderPoint,
      images: images ?? this.images,
      shelfLife: shelfLife ?? this.shelfLife,
      attaType: attaType ?? this.attaType,
      ingredients: ingredients ?? this.ingredients,
    );
  }
}

class Productt implements IEntity<Productt> {
  String? id;
  String name;
  String brand;
  String user;
  String categoryPath;
  String categoryName;
  String description;
  String keyfeatures;
  String manufacturer;
  String? tags;
  String countryOrigin;
  String customerCareDetails;
  String disclaimer;
  String returnPolicy;
  String nutritionInformation;
  Map<String, dynamic> highLights;
  Map<String, dynamic> info;

  List<Variation> variations;
  final List<String> images;

  Productt(
      {this.id,
      required this.name,
      required this.brand,
      required this.user,
      required this.categoryPath,
      required this.categoryName,
      required this.description,
      required this.keyfeatures,
      required this.manufacturer,
      this.tags,
      required this.countryOrigin,
      required this.customerCareDetails,
      required this.disclaimer,
      required this.returnPolicy,
      required this.nutritionInformation,
      this.variations = const [],
      this.images = const [],
      this.highLights = const {},
      this.info = const {}});

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "brand": brand,
      "user": user,
      "categorypath": categoryPath,
      "categoryname": categoryName,
      "description": description,
      "keyfeatures": keyfeatures,
      "manufacturer": manufacturer,
      "tags": tags,
      "countryorigin": countryOrigin,
      "customercaredetails": customerCareDetails,
      "disclaimer": disclaimer,
      "returnpolicy": returnPolicy,
      "nutritioninformation": nutritionInformation,
      "variations": variations.map((v) => v.toMap()).toList(),
      "images": images,
      "highlights": highLights,
      "info": info
    };
  }

  @override
  Productt copyWith({
    String? id,
    String? name,
    String? brand,
    String? user,
    String? categoryPath,
    String? categoryName,
    String? description,
    String? keyfeatures,
    String? manufacturer,
    String? tags,
    String? countryOrigin,
    String? customerCareDetails,
    String? disclaimer,
    String? returnPolicy,
    String? nutritionInformation,
    List<Variation>? variations,
    List<String>? images,
    Map<String, dynamic>? hightLights,
    Map<String, dynamic>? info,
  }) {
    return Productt(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      user: user ?? this.user,
      categoryPath: categoryPath ?? this.categoryPath,
      categoryName: categoryName ?? this.categoryName,
      description: description ?? this.description,
      keyfeatures: keyfeatures ?? this.keyfeatures,
      manufacturer: manufacturer ?? this.manufacturer,
      tags: tags ?? this.tags,
      countryOrigin: countryOrigin ?? this.countryOrigin,
      customerCareDetails: customerCareDetails ?? this.customerCareDetails,
      disclaimer: disclaimer ?? this.disclaimer,
      returnPolicy: returnPolicy ?? this.returnPolicy,
      nutritionInformation: nutritionInformation ?? this.nutritionInformation,
      variations: variations ?? this.variations,
      images: images ?? this.images,
    );
  }

  factory Productt.fromMap(Map<String, dynamic> data) {
    return Productt(
      id: data["id"],
      name: data["name"],
      brand: data["brand"],
      user: data["user"] ?? '',
      categoryPath: data["categorypath"] ?? '',
      categoryName: data["categoryname"] ?? '',
      description: data["productdescription"] ?? '',
      keyfeatures: data["keyfeatures"] ?? '',
      manufacturer: data["manufacturer"],
      tags: data["tags"],
      countryOrigin: data["countryoforigin"] ?? '',
      customerCareDetails: data["customercaredetails"] ?? '',
      disclaimer: data["disclaimer"] ?? '',
      returnPolicy: data["returnpolicy"] ?? '',
      nutritionInformation: data["nutritioninformation"] ?? '',
      variations: (data["variations"] as List<dynamic>?)
              ?.map<Variation>((v) =>
                  ModelRegistry.fromMap<Variation>(v as Map<String, dynamic>))
              .toList() ??
          [],
      highLights: data["highlights"] ?? {},
      info: data["info"] ?? {},
    );
  }

  Variation getVariation(String variationId) {
    Variation variation = variations.firstWhere((v) => v.id == variationId);
    return variation;
  }
}
