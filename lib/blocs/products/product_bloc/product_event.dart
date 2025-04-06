part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class AddProductEvent extends ProductEvent {}

class PickImages extends ProductEvent {}

class RemoveImage extends ProductEvent {
  int index;
  RemoveImage(this.index);
}

class UploadImages extends ProductEvent {}

class FetchProductEvent extends ProductEvent {}

class AddDescription extends ProductEvent {
  String description;
  AddDescription(this.description);
}

class RemoveDescription extends ProductEvent {
  int index;
  RemoveDescription(this.index);
}

class ProductName extends ProductEvent {
  String productName;
  ProductName(this.productName);
}

class ProductBrand extends ProductEvent {
  String productBrand;
  ProductBrand(this.productBrand);
}

class ProductCategory extends ProductEvent {
  String productCategory;
  ProductCategory(this.productCategory);
}

class SellingUnit extends ProductEvent {
  String value;
  SellingUnit(this.value);
}

class QuantityInBox extends ProductEvent {
  String value;
  QuantityInBox(this.value);
}

class Mrp extends ProductEvent {
  String value;
  Mrp(this.value);
}

class SellingPrice extends ProductEvent {
  String value;
  SellingPrice(this.value);
}

class SetCategory extends ProductEvent {
  String category;
  SetCategory(this.category);
}

class SetDiscount extends ProductEvent {
  String discount;
  SetDiscount(this.discount);
}

class SetQuantity extends ProductEvent {
  String quantity;
  SetQuantity(this.quantity);
}

class SetSummary extends ProductEvent {
  String summaryText;
  SetSummary(this.summaryText);
}

class SetKeyFeatures extends ProductEvent {
  String keyFeatureText;
  SetKeyFeatures(this.keyFeatureText);
}

class ClearMrpError extends ProductEvent {}

class ShowQuantityInBoxField extends ProductEvent {}

class ProductCreate extends ProductEvent {}
