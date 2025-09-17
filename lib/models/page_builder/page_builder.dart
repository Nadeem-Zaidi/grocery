import 'package:grocery_app/database_service.dart/dashboard/section.dart';

class PageBuilder {
  final String? name;
  final Map<String, Section> sections;
  final Map<String, Section> promoBanner;
  final String? appBarColor;

  PageBuilder({
    this.sections = const {},
    this.name,
    this.promoBanner = const {},
    this.appBarColor,
  });

  PageBuilder copyWith({
    String? name,
    Map<String, Section>? sections,
    Map<String, Section>? promoBanner,
    String? appBarColor,
  }) {
    return PageBuilder(
      name: name ?? this.name,
      sections: sections ?? this.sections,
      promoBanner: promoBanner ?? this.promoBanner,
      appBarColor: appBarColor ?? this.appBarColor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'appbarcolor': appBarColor,
      'sections': sections.map((key, value) => MapEntry(key, value.toMap())),
      'promobanner':
          promoBanner.map((key, value) => MapEntry(key, value.toMap())),
    };
  }

  factory PageBuilder.fromMap(Map<String, dynamic> map) {
    return PageBuilder(
      name: map['name'] as String?,
      sections: (map['sections'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, Section.fromMap(value)),
      ),
    );
  }
}
