class Category {
  String? id;
  String? name;
  String? parent;
  String? path;
  String? url;

  Category({this.id, this.path, this.url, required this.name, this.parent});

  Category copyWith(
      {String? id, String? name, String? parent, String? path, String? url}) {
    return Category(
        id: id ?? this.id,
        name: name ?? this.name,
        parent: parent ?? this.parent,
        path: path ?? this.path,
        url: url ?? this.url);
  }

  factory Category.fromMap(Map<String, dynamic> m) {
    return Category(
      id: m["id"] ?? "",
      name: m["name"] ?? "",
      parent: m["parent"] ?? "",
      path: m["path"] ?? "",
      url: m["url"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "parent": parent, "path": path, "url": url};
  }
}
