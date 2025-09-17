sealed class CustomCard {
  const CustomCard();

  Map<String, dynamic> toMap();

  static CustomCard fromMap(Map<String, dynamic> map) {
    switch (map['type']) {
      case 'plain':
        return PlainCard.fromMap(map);
      case 'discount':
        return DiscountCard.fromMap(map);
      case 'featured':
        return FeaturedCard.fromMap(map);
      default:
        throw Exception("Unknown card type: ${map['type']}");
    }
  }
}

class PlainCard extends CustomCard {
  final String title;
  final String imageUrl;
  final String? backGroundColor;

  const PlainCard({
    required this.title,
    required this.imageUrl,
    this.backGroundColor,
  });

  PlainCard copyWith({
    String? title,
    String? imageUrl,
    String? backGroundColor,
  }) {
    return PlainCard(
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      backGroundColor: backGroundColor ?? this.backGroundColor,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'plain',
      'title': title,
      'imageUrl': imageUrl,
      if (backGroundColor != null) 'backGroundColor': backGroundColor,
    };
  }

  factory PlainCard.fromMap(Map<String, dynamic> map) {
    return PlainCard(
      title: map['title'] as String,
      imageUrl: map['imageUrl'] as String,
      backGroundColor: map['backGroundColor'] as String?,
    );
  }
}

class DiscountCard extends CustomCard {
  const DiscountCard();

  DiscountCard copyWith() => const DiscountCard();

  @override
  Map<String, dynamic> toMap() => {'type': 'discount'};

  factory DiscountCard.fromMap(Map<String, dynamic> _) => const DiscountCard();
}

class FeaturedCard extends CustomCard {
  const FeaturedCard();

  FeaturedCard copyWith() => const FeaturedCard();

  @override
  Map<String, dynamic> toMap() => {'type': 'featured'};

  factory FeaturedCard.fromMap(Map<String, dynamic> _) => const FeaturedCard();
}
