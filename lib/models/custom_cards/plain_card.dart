part of 'customcard.dart';

class PlainCard extends CustomCard {
  final Color? color;
  const PlainCard(
      {required super.imageUrl,
      super.backGroundColor,
      required super.type,
      super.title,
      super.key,
      this.color});

  factory PlainCard.initial() {
    return PlainCard(imageUrl: "", type: "plain", title: "", color: null);
  }

  @override
  PlainCard copyWith({
    String? title,
    String? imageUrl,
    String? backGroundColor,
    String? type,
    Color? color,
  }) {
    return PlainCard(
        title: title ?? this.title,
        imageUrl: imageUrl ?? this.imageUrl,
        backGroundColor: backGroundColor ?? this.backGroundColor,
        type: type ?? this.type,
        color: color ?? color);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'title': title,
      'imageUrl': imageUrl,
      if (backGroundColor != null) 'backGroundColor': backGroundColor,
    };
  }

  factory PlainCard.fromMap(Map<String, dynamic> map) {
    return PlainCard(
      title: map['title'] as String,
      imageUrl: map['imageUrl'] as String,
      type: map['type'] as String,
      backGroundColor: map['backGroundColor'] as String?,
    );
  }
}
