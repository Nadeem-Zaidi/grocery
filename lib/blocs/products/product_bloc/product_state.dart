part of 'product_bloc.dart';

@immutable
class ProductState extends Equatable {
  final String? productName;
  final String? productBrand;
  final String? productCategory;
  final String? sellingUnit;
  final int? quantityInBox;
  final int? quantity;
  final double? mrp;
  final double? sellingPrice;
  final double? discount;
  final List<Product> products;
  final List<String> imageUrls;
  final List<XFile> imageFiles;
  final List<String> imageUploadedUrls;
  final List<String> description;
  final String? summary;
  final String? keyFeatures;
  final bool isLoading;
  final String? error;
  final bool showQuantityInBox;
  final String? user;
  final String? productNameInputError;
  final String? brandInputError;
  final String? sellingUnitInputError;
  final String? mrpInputError;
  final String? sellingPriceInputError;
  final String? discountInputError;
  final String? availableQuantityError;
  final String? descriptionInputError;
  final String? quantityInBoxInputError;

  const ProductState({
    this.productName,
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
    this.summary,
    this.keyFeatures,
    this.isLoading = false,
    this.error,
    this.showQuantityInBox = false,
    this.user,
    this.productNameInputError,
    this.brandInputError,
    this.sellingUnitInputError,
    this.mrpInputError,
    this.sellingPriceInputError,
    this.discountInputError,
    this.availableQuantityError,
    this.descriptionInputError,
    this.quantityInBoxInputError,
  });

  factory ProductState.initial() => const ProductState();

  ProductState copyWith({
    String? productName,
    String? productBrand,
    String? productCategory,
    String? sellingUnit,
    int? quantityInBox,
    int? quantity,
    double? mrp,
    double? sellingPrice,
    double? discount,
    List<Product>? products,
    List<String>? imageUrls,
    List<XFile>? imageFiles,
    List<String>? imageUploadedUrls,
    List<String>? description,
    String? summary,
    String? keyFeatures,
    bool? isLoading,
    String? error,
    bool? showQuantityInBox,
    String? user,
    String? productNameInputError,
    String? brandInputError,
    String? sellingUnitInputError,
    String? mrpInputError,
    String? sellingPriceInputError,
    String? discountInputError,
    String? availableQuantityError,
    String? descriptionInputError,
    String? quantityInBoxInputError,
  }) {
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
      products: products ?? this.products,
      imageUrls: imageUrls ?? this.imageUrls,
      imageFiles: imageFiles ?? this.imageFiles,
      imageUploadedUrls: imageUploadedUrls ?? this.imageUploadedUrls,
      description: description ?? this.description,
      summary: summary ?? this.keyFeatures,
      keyFeatures: keyFeatures ?? this.keyFeatures,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      showQuantityInBox: showQuantityInBox ?? this.showQuantityInBox,
      user: user ?? this.user,
      productNameInputError:
          productNameInputError ?? this.productNameInputError,
      brandInputError: brandInputError ?? this.brandInputError,
      sellingUnitInputError:
          sellingUnitInputError ?? this.sellingUnitInputError,
      mrpInputError: mrpInputError ?? this.mrpInputError,
      sellingPriceInputError:
          sellingPriceInputError ?? this.sellingPriceInputError,
      discountInputError: discountInputError ?? this.discountInputError,
      availableQuantityError:
          availableQuantityError ?? this.availableQuantityError,
      descriptionInputError:
          descriptionInputError ?? this.descriptionInputError,
      quantityInBoxInputError:
          quantityInBoxInputError ?? this.quantityInBoxInputError,
    );
  }

  @override
  List<Object?> get props => [
        productName,
        productBrand,
        productCategory,
        sellingUnit,
        quantityInBox,
        quantity,
        mrp,
        sellingPrice,
        discount,
        products,
        imageUrls,
        imageFiles.map((f) => f.path).toList(),
        imageUploadedUrls,
        description,
        summary,
        keyFeatures,
        isLoading,
        error,
        showQuantityInBox,
        user,
        productNameInputError,
        brandInputError,
        sellingUnitInputError,
        mrpInputError,
        sellingPriceInputError,
        discountInputError,
        availableQuantityError,
        descriptionInputError,
        quantityInBoxInputError,
      ];

  @override
  String toString() {
    return 'ProductState('
        'productName: $productName, '
        'productBrand: $productBrand, '
        'productCategory: $productCategory, '
        'sellingUnit: $sellingUnit, '
        'quantityInBox: $quantityInBox, '
        'quantity: $quantity, '
        'mrp: $mrp, '
        'sellingPrice: $sellingPrice, '
        'discount: $discount, '
        'products: ${products.length} items, '
        'imageUrls: ${imageUrls.length} urls, '
        'imageFiles: ${imageFiles.length} files, '
        'imageUploadedUrls: ${imageUploadedUrls.length} urls, '
        'description: $description, '
        'summary: $summary, '
        'keyFeatures: $keyFeatures'
        'isLoading: $isLoading, '
        'error: $error, '
        'showQuantityInBox: $showQuantityInBox, '
        'user: $user, '
        'productNameInputError: $productNameInputError, '
        'brandInputError: $brandInputError, '
        'sellingUnitInputError: $sellingUnitInputError, '
        'mrpInputError: $mrpInputError, '
        'sellingPriceInputError: $sellingPriceInputError, '
        'discountInputError: $discountInputError, '
        'availableQuantityError: $availableQuantityError, '
        'descriptionInputError: $descriptionInputError, '
        'quantityInBoxInputError: $quantityInBoxInputError'
        ')';
  }
}
