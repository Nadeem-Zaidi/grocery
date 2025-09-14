import 'package:grocery_app/database_service.dart/dashboard/section.dart';

class Dashboard {
  final String? name;
  final Map<String, Section> sections;

  Dashboard({
    this.sections = const {},
    this.name,
  });

  Dashboard copyWith({
    String? name,
    Map<String, Section>? sections,
  }) {
    return Dashboard(
      name: name ?? this.name,
      sections: sections ?? this.sections,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sections': sections.map((key, value) => MapEntry(key, value.toMap())),
    };
  }

  factory Dashboard.fromMap(Map<String, dynamic> map) {
    return Dashboard(
      name: map['name'] as String?,
      sections: (map['sections'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, Section.fromMap(value)),
      ),
    );
  }
}
