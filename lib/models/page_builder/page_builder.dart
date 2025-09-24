import 'package:grocery_app/database_service.dart/dashboard/section.dart';
import 'package:image_picker/image_picker.dart';

class PageBuilder {
  final String? name;
  final Map<String, Section> sections;
  final Map<String, Section> promoBanner;
  final String? dominantColorAppBar;
  final bool showOnUi;
  final XFile? appBarImage;

  PageBuilder({
    this.sections = const {},
    this.name,
    this.promoBanner = const {},
    this.dominantColorAppBar,
    this.showOnUi = false,
    this.appBarImage,
  });

  PageBuilder copyWith({
    String? name,
    Map<String, Section>? sections,
    Map<String, Section>? promoBanner,
    String? dominantColorAppBar,
    bool? showOnUi,
    XFile? appBarImage,
  }) {
    return PageBuilder(
      name: name ?? this.name,
      sections: sections ?? this.sections,
      promoBanner: promoBanner ?? this.promoBanner,
      dominantColorAppBar: dominantColorAppBar ?? this.dominantColorAppBar,
      showOnUi: showOnUi ?? this.showOnUi,
      appBarImage: appBarImage ?? this.appBarImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'appbarcolor': dominantColorAppBar,
      'appBarImage': appBarImage,
      'sections': sections.map((key, value) => MapEntry(key, value.toMap())),
      'promobanner':
          promoBanner.map((key, value) => MapEntry(key, value.toMap())),
      'showonui': showOnUi
    };
  }

  factory PageBuilder.fromMap(Map<String, dynamic> map) {
    return PageBuilder(
      name: map['name'] as String?,
      sections: (map['sections'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, Section.fromMap(value)),
      ),
      promoBanner: (map['promobanner'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, Section.fromMap(value))),
    );
  }
}
