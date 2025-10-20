library custom_card;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'plain_card_with_title.dart';
part 'discount_card.dart';
part 'featured_card.dart';
part 'plain_card.dart';
part 'plain_card_gridview.dart';

abstract class CustomCard {
  final Key? key;
  final String? title;
  final String imageUrl;
  final String? backGroundColor;
  final String type;

  const CustomCard(
      {this.key,
      required this.imageUrl,
      required this.type,
      this.backGroundColor,
      this.title});

  Map<String, dynamic> toMap();
  CustomCard copyWith();

  static CustomCard fromMap(Map<String, dynamic> map) {
    switch (map['type']) {
      case 'plain':
        return PlainCardWithTitle.fromMap(map);
      case 'discount':
        return DiscountCard.fromMap(map);
      case 'featured':
        return FeaturedCard.fromMap(map);
      default:
        throw Exception("Unknown card type: ${map['type']}");
    }
  }
}
