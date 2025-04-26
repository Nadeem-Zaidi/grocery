class Section<T> {
  String? name;
  int? sequence;
  String? type;
  List<T> elements;

  Section({this.sequence, this.name, this.type, this.elements = const []});

  factory Section.fromMap(Map<String, dynamic> map) {
    return Section(
      sequence: map["sequence"],
      type: map["type"],
      name: map["name"],
      elements: List<T>.from(map["elements"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "sequence": sequence,
      "name": name,
      "type": type,
      "element": elements
    };
  }
}
