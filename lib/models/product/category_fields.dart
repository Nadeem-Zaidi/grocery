class ProductAttributes {
  String categoryName;
  Map<String, dynamic> attributes;

  ProductAttributes({required this.categoryName, required this.attributes});

  dynamic getAttribute(String keyName) {
    if (attributes.containsKey(keyName)) {
      return attributes[keyName];
    }
  }
}
