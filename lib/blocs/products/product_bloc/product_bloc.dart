import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:grocery_app/database_service.dart/inventory/firebase_inventory_service.dart';
import 'package:grocery_app/database_service.dart/product/firestore_product_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:collection/collection.dart';

import '../../../models/inventory/inventory.dart';
import '../../../models/product/product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FirestoreProductService productDb;
  final FirestoreInventoryService inventoryDb;
  final ImagePicker _picker = ImagePicker();
  final currentLoggedInUser = FirebaseAuth.instance.currentUser;

  ProductBloc(this.productDb, this.inventoryDb)
      : super(ProductState.initial()) {
    on<ProductEvent>((event, emit) async {
      switch (event) {
        case AddProductEvent():
          throw UnimplementedError();
        case PickImages():
          await pickImages(emit);
          throw UnimplementedError();
        case FetchProductEvent():
          throw UnimplementedError();
        case RemoveImage(index: int index):
          removeImage(emit, index);
        case UploadImages():
          await uploadImages(emit);
        case AddDescription(description: String description):
          addDescription(emit, description);
        case RemoveDescription(index: int index):
          removeDescription(emit, index);
        case ShowQuantityInBoxField():
          showQuantityInBox(emit);
        case SellingUnit(value: String value):
          sellingUnit(emit, value);
        case ProductName(productName: String productname):
          productNameController(emit, productname);
        case ProductBrand(productBrand: String productBrand):
          productBrandController(emit, productBrand);

        case ProductCategory(productCategory: String productCategory):
          productCategoryController(emit, productCategory);

        case QuantityInBox(value: String qib):
          quantityBox(emit, qib);

        case Mrp(value: String value):
          productMrp(emit, value);

        case SellingPrice(value: String value):
          productSP(emit, value);
        case SetCategory(category: String category):
          setCategory(emit, category);
        case SetDiscount(discount: String value):
          setDiscount(emit, value);

        case SetQuantity(quantity: String q):
          setQuantity(emit, q);
        case ProductCreate():
          await createProduct(emit);
      }
    });
  }

  Future<void> pickImages(Emitter<ProductState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));

      final List<XFile>? pickedFiles = await _picker.pickMultiImage();

      if (pickedFiles != null && pickedFiles.length <= 6) {
        emit(state.copyWith(
          isLoading: false,
          imageFiles: [
            ...state.imageFiles,
            ...List<XFile>.from(pickedFiles)
          ], // Ensuring deep copy
        ));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      print("Error occurred while picking images: $e");
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void removeImage(Emitter<ProductState> emit, int index) {
    try {
      if (index < 0 || index >= state.imageFiles.length) {
        throw RangeError('Index $index is out of bounds');
      }

      final updatedFiles = List<XFile>.from(state.imageFiles)..removeAt(index);

      emit(state.copyWith(
        imageFiles: updatedFiles,
        // Clear any previous errors
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to remove image: ${e.toString()}',
      ));
    }
  }

  Future<void> uploadImages(Emitter<ProductState> emit) async {
    for (var i in state.imageFiles) {
      print(i.path);
    }

    print(state.toString());
    // if (state.imageFiles.isEmpty) return;

    // List<String> urls = [];

    // try {
    //   emit(state.copyWith(isLoading: true));

    //   for (XFile file in state.imageFiles) {
    //     File imageFile = File(file.path);
    //     String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    //     Reference storageRef =
    //         FirebaseStorage.instance.ref().child("images/$fileName.jpg");

    //     UploadTask uploadTask = storageRef.putFile(imageFile);
    //     TaskSnapshot snapshot = await uploadTask;
    //     String url = await snapshot.ref.getDownloadURL();

    //     if (url.isEmpty) {
    //       throw Exception("Image upload failed, no URL returned.");
    //     }

    //     urls.add(url);
    //   }

    //   if (urls.isEmpty) {
    //     throw Exception("Could not upload any images");
    //   }

    //   emit(state.copyWith(isLoading: false, imageUloadedUrls: urls));
    // } catch (e) {
    //   print("Error during image upload: $e");
    //   emit(state.copyWith(isLoading: false, error: e.toString()));
    // }
  }

  /// **Create Product with Uploaded Images**
  Future<void> createProduct(Emitter<ProductState> emit) async {
    if (state.imageFiles.isEmpty) return;

    List<String> urls = [];

    try {
      emit(state.copyWith(isLoading: true));

      for (XFile file in state.imageFiles) {
        File imageFile = File(file.path);
        String fileName = DateTime.now().microsecondsSinceEpoch.toString();
        Reference storageRef =
            FirebaseStorage.instance.ref().child("images/$fileName.jpg");

        UploadTask uploadTask = storageRef.putFile(imageFile);
        TaskSnapshot snapshot = await uploadTask;
        String url = await snapshot.ref.getDownloadURL();

        if (url.isEmpty) {
          throw Exception("Image upload failed, no URL returned.");
        }

        urls.add(url);
      }

      if (urls.isEmpty) {
        throw Exception("Could not upload any images");
      }

      emit(state.copyWith(isLoading: false, imageUploadedUrls: urls));

      List<String> productRequiredFields = [
        "name",
        "brand",
        "category",
        "description"
      ];

      Map<String, dynamic> productMap = {
        "name": state.productName,
        "brand": state.productBrand,
        "category": state.productCategory,
        "description": state.description,
      };

      List<String> missingProductField = productMap.entries
          .where((entry) => entry.value == null)
          .map((entry) => entry.key)
          .toList();
      if (missingProductField.isNotEmpty) {
        emit(state.copyWith(
            error: "Fields are required ${missingProductField.join(",")}"));
        return;
      }

      Map<String, dynamic> productDataToUpload = {
        ...productMap,
        "images": state.imageUploadedUrls
      };

      Product? product =
          await productDb.create(Product.fromMap(productDataToUpload));

      if (product?.id != null || product?.id != "") {
        Map<String, dynamic> inventoryMap = {
          "productId": product?.id,
          "unit": state.sellingUnit,
          "quantityInBox": state.quantityInBox,
          "quantityAvailable": state.quantity,
          "mrp": state.mrp,
          "sellingPrice": state.sellingPrice,
          "discount": state.discount
        };

        List<String> inventoryMissingFields = inventoryMap.entries
            .where((entry) => (entry.value == null || entry.value == ""))
            .map((item) => item.key)
            .toList();
        if (inventoryMissingFields.isEmpty) {
          emit(state.copyWith(
              error:
                  "Inventory fiels ${inventoryMissingFields.join(",")} missing"));
          return;
        }

        Inventory? inventory =
            await inventoryDb.create(Inventory.fromMap(inventoryMap));
      }
    } catch (e) {
      print("Error occured in product creation ==> ${e.toString()}");
    }
  }

  void addDescription(Emitter<ProductState> emit, String description) {
    try {
      emit(state.copyWith(description: [...state.description, description]));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void removeDescription(Emitter<ProductState> emit, int index) {
    try {
      final updatedDescriptionList = List<String>.from(state.description)
        ..removeAt(index);
      emit(state.copyWith(description: updatedDescriptionList));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void showQuantityInBox(Emitter<ProductState> emit) {
    emit(state.copyWith(showQuantityInBox: true));
  }

  void productNameController(Emitter<ProductState> emit, String value) {
    emit(state.copyWith(productName: value));
  }

  void productBrandController(Emitter<ProductState> emit, String value) {
    emit(state.copyWith(productBrand: value));
  }

  void productCategoryController(Emitter<ProductState> emit, String value) {
    emit(state.copyWith(productCategory: value));
  }

  void sellingUnit(Emitter<ProductState> emit, String value) {
    try {
      if (value.toString().toLowerCase() == "box") {
        emit(state.copyWith(showQuantityInBox: true, sellingUnit: value));
      } else {
        emit(state.copyWith(showQuantityInBox: false, sellingUnit: value));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void quantityBox(Emitter<ProductState> emit, String value) {
    emit(state.copyWith(quantityInBox: value));
  }

  void productMrp(Emitter<ProductState> emit, String value) {
    emit(state.copyWith(mrp: value));
  }

  void productSP(Emitter<ProductState> emit, String value) {
    emit(state.copyWith(sellingPrice: value));
  }

  void setCategory(Emitter<ProductState> emit, String value) {
    emit(state.copyWith(productCategory: value));
  }

  void setDiscount(Emitter<ProductState> emit, String value) {
    emit(state.copyWith(discount: value));
  }

  void setQuantity(Emitter<ProductState> emit, String value) {
    emit(state.copyWith(quantity: value));
  }
}
