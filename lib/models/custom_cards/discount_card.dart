part of 'customcard.dart';

class DiscountCard extends CustomCard {
  double discount;
  DiscountCard(
      {required super.imageUrl,
      super.backGroundColor,
      super.type = 'discount',
      this.discount = 0.0});

  @override
  DiscountCard copyWith(
      {String? imageUrl,
      String? backGroundColor,
      String? type,
      double? discount}) {
    return DiscountCard(
        imageUrl: imageUrl ?? this.imageUrl,
        backGroundColor: backGroundColor ?? this.backGroundColor,
        type: type ?? this.type,
        discount: discount ?? this.discount);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'imageUrl': imageUrl,
      'discount': discount,
      if (backGroundColor != null) 'backGroundColor': backGroundColor,
    };
  }

  factory DiscountCard.fromMap(Map<String, dynamic> map) {
    return DiscountCard(
        imageUrl: map['imageUrl'] as String,
        backGroundColor: map['backGroundColor'] as String?,
        type: map['type'] as String,
        discount: map['discount'] as double);
  }
}
