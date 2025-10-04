part of 'customcard.dart';

class FeaturedCard extends CustomCard {
  const FeaturedCard({
    required super.imageUrl,
    super.backGroundColor,
    super.type = 'featured',
  });

  @override
  FeaturedCard copyWith({
    String? imageUrl,
    String? backGroundColor,
    String? type,
  }) {
    return FeaturedCard(
      imageUrl: imageUrl ?? this.imageUrl,
      backGroundColor: backGroundColor ?? this.backGroundColor,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'imageUrl': imageUrl,
      if (backGroundColor != null) 'backGroundColor': backGroundColor,
    };
  }

  factory FeaturedCard.fromMap(Map<String, dynamic> map) {
    return FeaturedCard(
      imageUrl: map['imageUrl'] as String,
      backGroundColor: map['backGroundColor'] as String?,
      type: map['type'] as String,
    );
  }
}
