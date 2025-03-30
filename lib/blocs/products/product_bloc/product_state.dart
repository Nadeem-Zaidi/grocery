part of 'product_bloc.dart';

@immutable
class ProductState {
  final String? productName;
  final String? productBrand;
  final String? productCategory;
  final String? sellingUnit;
  final String? quantityInBox;
  String? quantity;
  final String? mrp;
  final String? sellingPrice;
  String? discount;
  final List<Product> products;
  final List<String> imageUrls;
  final List<XFile> imageFiles;
  final List<String> imageUploadedUrls;
  final List<String> description;
  final bool isLoading;
  final String? error;
  final bool showQuantityInBox;
  final String? user;

  ProductState(
      {this.productName,
      this.productBrand,
      this.productCategory,
      this.sellingUnit,
      this.quantityInBox,
      this.quantity,
      this.mrp,
      this.sellingPrice,
      this.discount,
      this.products = const [],
      this.imageUrls = const [],
      this.imageFiles = const [],
      this.imageUploadedUrls = const [],
      this.description = const [],
      this.isLoading = false,
      this.error,
      this.showQuantityInBox = false,
      this.user});

  /// Factory constructor for initial state
  factory ProductState.initial() {
    return ProductState();
  }

  ProductState copyWith(
      {String? productName,
      String? productBrand,
      String? productCategory,
      String? sellingUnit,
      String? quantityInBox,
      String? quantity,
      String? mrp,
      String? sellingPrice,
      String? discount,
      List<Product>? products,
      List<String>? imageUrls,
      List<XFile>? imageFiles,
      List<String>? imageUploadedUrls,
      List<String>? description,
      bool? isLoading,
      String? error,
      bool? showQuantityInBox,
      String? user}) {
    return ProductState(
      productName: productName ?? this.productName,
      productBrand: productBrand ?? this.productBrand,
      productCategory: productCategory ?? this.productCategory,
      sellingUnit: sellingUnit ?? this.sellingUnit,
      quantityInBox: quantityInBox ?? this.quantityInBox,
      quantity: quantity ?? this.quantity,
      mrp: mrp ?? this.mrp,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      discount: discount ?? this.discount,
      products: products ?? List.unmodifiable(this.products),
      imageUrls: imageUrls ?? List.unmodifiable(this.imageUrls),
      imageFiles: imageFiles ?? List.unmodifiable(this.imageFiles),
      imageUploadedUrls:
          imageUploadedUrls ?? List.unmodifiable(this.imageUploadedUrls),
      description: description ?? List.unmodifiable(this.description),
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      showQuantityInBox: showQuantityInBox ?? this.showQuantityInBox,
      user: user ?? this.user,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductState &&
        other.productName == productName &&
        other.productBrand == productBrand &&
        other.productCategory == productCategory &&
        other.sellingUnit == sellingUnit &&
        other.quantityInBox == quantityInBox &&
        other.mrp == mrp &&
        other.sellingPrice == sellingPrice &&
        const DeepCollectionEquality().equals(other.products, products) &&
        const DeepCollectionEquality().equals(other.imageUrls, imageUrls) &&
        const DeepCollectionEquality().equals(other.imageFiles, imageFiles) &&
        const DeepCollectionEquality()
            .equals(other.imageUploadedUrls, imageUploadedUrls) &&
        const DeepCollectionEquality().equals(other.description, description) &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.showQuantityInBox == showQuantityInBox &&
        other.user == user &&
        other.discount == discount &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return Object.hash(
        productName,
        productBrand,
        productCategory,
        sellingUnit,
        quantityInBox,
        mrp,
        sellingPrice,
        const DeepCollectionEquality().hash(products),
        const DeepCollectionEquality().hash(imageUrls),
        const DeepCollectionEquality().hash(imageFiles),
        const DeepCollectionEquality().hash(imageUploadedUrls),
        const DeepCollectionEquality().hash(description),
        isLoading,
        error,
        showQuantityInBox,
        user,
        discount,
        quantity);
  }

  @override
  String toString() {
    return 'ProductState('
        'productName: $productName, '
        'productBrand: $productBrand, '
        'productCategory: $productCategory, '
        'sellingUnit: $sellingUnit, '
        'quantityInBox: $quantityInBox, '
        'mrp: $mrp, '
        'sellingPrice: $sellingPrice, '
        'products: ${products.length}, '
        'imageUrls: ${imageUrls.length}, '
        'imageFiles: ${imageFiles.length}, '
        'imageUploadedUrls: ${imageUploadedUrls.length}, '
        'description: $description, '
        'isLoading: $isLoading, '
        'error: $error, '
        'showQuantityInBox: $showQuantityInBox'
        'user:$user '
        'quantity:$quantity '
        'discount:$discount '
        ')';
  }
}
