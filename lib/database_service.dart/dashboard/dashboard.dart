import 'package:grocery_app/database_service.dart/dashboard/section.dart';

class Dashboard {
  List<Section> sections;
  Dashboard({this.sections = const []});

  Map<String, dynamic> toMap() {
    return {
      'sections': sections.map((e) => e.toMap()).toList(),
    };
  }

  factory Dashboard.fromMap(Map<String, dynamic> map) {
    return Dashboard(
      sections: (map['sections'] as List<dynamic>)
          .map((e) => Section.fromMap(e))
          .toList(),
    );
  }
}
