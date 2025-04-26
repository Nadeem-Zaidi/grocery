import 'package:grocery_app/models/category.dart';

import '../product/product.dart';

sealed class DashboaredElement {}

class ProductElement extends DashboaredElement {
  Product product;
  ProductElement({required this.product});
}

class CategoryElement extends DashboaredElement {
  Category category;
  CategoryElement({required this.category});
}
