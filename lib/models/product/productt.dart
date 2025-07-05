import 'package:flutter/material.dart';
import 'package:grocery_app/database_service.dart/ientity.dart';
import 'dart:collection';

class Inventory implements IEntity<Inventory> {
  final String id;
  final double mrp;
  final double discount;
  final double sellingPrice;
  final String status;
  final String reorderPoint;
  final int quantityInHand;
  Inventory(
      {required this.id,
      required this.mrp,
      required this.discount,
      required this.sellingPrice,
      required this.status,
      required this.reorderPoint,
      this.quantityInHand = 0});

  @override
  Inventory copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}

class Variation implements IEntity<Variation> {
  final String id;
  final String name;
  final String sku;
  final Map<String, dynamic> highLights;
  final Map<String, dynamic> info;
  final Productt parent;
  final Inventory inventory;

  Variation({
    required this.id,
    required this.name,
    this.highLights = const {},
    this.info = const {},
    required this.sku,
    required this.parent,
    required this.inventory,
  });

  @override
  Variation copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}

class Productt implements IEntity<Productt> {
  String? id;
  final Map<String, dynamic> attributes;
  final Map<String, dynamic> highLightSection;
  final Map<String, dynamic> infoSection;
  final Map<String, dynamic> details;
  final String? type;
  final List<Variation> variations;

  Productt({
    this.type,
    this.attributes = const {},
    this.highLightSection = const {},
    this.infoSection = const {},
    this.details = const {},
    this.id,
    this.variations = const [],
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      "highlights": highLightSection,
      "info": infoSection,
      "details": details
    };
  }

  @override
  Productt copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  factory Productt.fromMap(Map<String, dynamic> data) {
    print(data);
    return Productt(
      id: data["id"],
      details: data["details"],
      infoSection: data["info"],
      highLightSection: data["highlights"],
    );
  }
}
