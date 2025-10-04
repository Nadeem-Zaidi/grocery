library custom_card;

part 'plain_card_with_title.dart';
part 'discount_card.dart';
part 'featured_card.dart';
part 'plain_card.dart';
part 'plain_card_gridview.dart';

abstract class CustomCard {
  final String? title;
  final String imageUrl;
  final String? backGroundColor;
  final String type;

  const CustomCard(
      {required this.imageUrl,
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
