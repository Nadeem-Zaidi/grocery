part of 'customcard.dart';

class PlainCardGridView extends CustomCard {
  const PlainCardGridView({
    required super.imageUrl,
    super.backGroundColor,
    required super.type,
    super.title,
  });

  factory PlainCardGridView.initial() {
    return PlainCardGridView(imageUrl: "", type: "plain", title: "");
  }

  @override
  PlainCard copyWith({
    String? title,
    String? imageUrl,
    String? backGroundColor,
    String? type,
  }) {
    return PlainCard(
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      backGroundColor: backGroundColor ?? this.backGroundColor,
      type: type ?? this.type,
    );
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

  factory PlainCardGridView.fromMap(Map<String, dynamic> map) {
    return PlainCardGridView(
      title: map['title'] as String,
      imageUrl: map['imageUrl'] as String,
      type: map['type'] as String,
      backGroundColor: map['backGroundColor'] as String?,
    );
  }
}
