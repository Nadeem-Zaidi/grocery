import 'package:grocery_app/database_service.dart/ientity.dart';

class Productt implements IEntity<Productt> {
  Map<String, dynamic> attributes;
  String? type;

  Productt({this.type, this.attributes = const {}});

  @override
  Map<String, dynamic> toMap() {
    return {...attributes};
  }

  @override
  Productt copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  factory Productt.fromMap(Map<String, dynamic> attributes) {
    return Productt(attributes: attributes);
  }
}
