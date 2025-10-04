import 'package:grocery_app/database_service.dart/dashboard/section.dart';
import 'package:image_picker/image_picker.dart';

class PageBuilder {
  final String? name;
  final Map<String, Section> sections;
  final Map<String, Section> promoBanner;
  final String? dominantColorAppBar;
  final String? darkDominantColor;
  final bool showOnUi;
  final XFile? appBarImage;
  final String? appBarImageUrl;
  final double appbarHeight;

  PageBuilder({
    this.sections = const {},
    this.name,
    this.promoBanner = const {},
    this.dominantColorAppBar,
    this.darkDominantColor,
    this.showOnUi = false,
    this.appBarImage,
    required this.appbarHeight,
    this.appBarImageUrl,
  });

  PageBuilder copyWith(
      {String? name,
      Map<String, Section>? sections,
      Map<String, Section>? promoBanner,
      String? dominantColorAppBar,
      String? darkDominantColor,
      bool? showOnUi,
      XFile? appBarImage,
      double? appbarHeight,
      String? appBarImageUrl}) {
    return PageBuilder(
      name: name ?? this.name,
      sections: sections ?? this.sections,
      promoBanner: promoBanner ?? this.promoBanner,
      dominantColorAppBar: dominantColorAppBar ?? this.dominantColorAppBar,
      darkDominantColor: darkDominantColor ?? this.darkDominantColor,
      showOnUi: showOnUi ?? this.showOnUi,
      appBarImage: appBarImage ?? this.appBarImage,
      appbarHeight: appbarHeight ?? this.appbarHeight,
      appBarImageUrl: appBarImageUrl ?? this.appBarImageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'appbarcolor': dominantColorAppBar,
      'appbarimageurl': appBarImageUrl,
      'darkdominantcolor': darkDominantColor,
      'appBarImage': appBarImage,
      'appbarheight': appbarHeight,
      'sections': sections.map((key, value) => MapEntry(key, value.toMap())),
      'promobanner':
          promoBanner.map((key, value) => MapEntry(key, value.toMap())),
      'showonui': showOnUi
    };
  }

  factory PageBuilder.fromMap(Map<String, dynamic> map) {
    return PageBuilder(
      name: map['name'] as String?,
      appbarHeight: map['appbarheight'],
      sections: (map['sections'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, Section.fromMap(value)),
      ),
      promoBanner: (map['promobanner'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, Section.fromMap(value))),
    );
  }
}
