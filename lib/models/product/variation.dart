class Variation {
  String? id;
  String? productId;
  String? name;
  List<String>? description;
  String? category;
  List<String>? tags;
  List<String>? images;
  bool active;
  bool onpage;

  Variation({
    this.id,
    this.productId,
    this.name,
    this.description,
    this.category,
    this.tags,
    this.images,
    this.active = true,
    this.onpage = false,
  });
}
