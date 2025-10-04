part of 'customcard.dart';

class PlainCardWithTitle extends CustomCard {
  final String title;

  const PlainCardWithTitle({
    required super.imageUrl,
    super.backGroundColor,
    super.type = 'plain',
    required this.title,
  });

  @override
  PlainCardWithTitle copyWith({
    String? title,
    String? imageUrl,
    String? backGroundColor,
    String? type,
  }) {
    return PlainCardWithTitle(
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

  factory PlainCardWithTitle.fromMap(Map<String, dynamic> map) {
    return PlainCardWithTitle(
      title: map['title'] as String,
      imageUrl: map['imageUrl'] as String,
      type: map['type'] as String,
      backGroundColor: map['backGroundColor'] as String?,
    );
  }
}
