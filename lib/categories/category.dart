class Category {
  String id;
  String name;
  String parent;
  String? path;

  Category(
      {this.path, required this.name, required this.parent, required this.id});

  Category copyWith({String? id, String? name, String? parent, String? path}) {
    return Category(
        id: id ?? this.id,
        name: name ?? this.name,
        parent: parent ?? this.parent,
        path: path ?? this.path);
  }

  factory Category.fromMap(Map<String, dynamic> m) {
    return Category(
        id: m["id"],
        name: m["name"],
        parent: m["parent"],
        path: m["path"] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "parent": parent,
      "path": path,
    };
  }
}
