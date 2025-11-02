import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/database_service.dart/IDBService.dart';
import 'package:grocery_app/database_service.dart/db_service.dart';
import 'package:grocery_app/database_service.dart/product/firestore_product_service.dart';
import 'package:grocery_app/models/form_config/form_config.dart';
import 'package:grocery_app/models/product/product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:math_expressions/math_expressions.dart';
import '../../models/category.dart';
import '../../models/product/productt.dart';
import 'package:uuid/uuid.dart';

part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormState> {
  final IDBService<FormConfig> dbService;
  final IDBService<dynamic> productService;
  final ImagePicker _imagePicker = ImagePicker();
  final String? forEntity;

  FormBloc(
      {required this.dbService, required this.productService, this.forEntity})
      : super(FormState.initial()) {
    on<SetFormCategory>(_setFormCategory);
    on<FieldChanged>(_onFieldChanged);
    on<FormInitialized>(_initialize);
    on<FormSave>(_onFormSave);
    on<FormPickImages>(_pickImages);
    on<FormRemovePickedImages>(_removePickedImages);
    on<ItemCreated>(_itemCreated);
  }

  Future<void> _setFormCategory(
      SetFormCategory event, Emitter<FormState> emit) async {
    try {
      emit(state.copyWith(
          category: event.category, selectedProduct: event.product));
    } catch (error) {
      emit(state.copyWith(error: "Can not set category"));
    }
  }

  Future<void> _pickImages(
      FormPickImages event, Emitter<FormState> emit) async {
    try {
      final List<XFile> pickProductImages = await _imagePicker.pickMultiImage();
      if (pickProductImages.length <= 6) {
        emit(state.copyWith(
            isLoading: false,
            productImages: [...state.productImages, ...pickProductImages]));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (error) {
      emit(state.copyWith(
          isLoading: false, error: "Something went wrong in loading images"));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _removePickedImages(
      FormRemovePickedImages event, Emitter<FormState> emit) async {
    int index = event.index;
    try {
      if (index < 0 && index >= state.productImages.length) {
        throw RangeError("Index is out of bound");
      }
      final updatedList = List<XFile>.from(state.productImages)
        ..removeAt(index);
      emit(state.copyWith(productImages: updatedList, error: null));
    } catch (error) {
      emit(state.copyWith(error: "Failed to remove image at index $index"));
    }
  }

  Future<void> _initialize(
      FormInitialized event, Emitter<FormState> emit) async {
    try {
      if (state.isLoading || state.hasReachedMax) return;

      emit(state.copyWith(isLoading: true, error: null));
      var (formConfig, lastDocument) =
          await dbService.getAll(15, "sequence", state.lastDocument);

      if (formConfig.isEmpty) {
        emit(state
            .copyWith(formConfig: [], isLoading: false, hasReachedMax: true));
        return;
      }

      Map<String, FormConfig> formConfigMap = Map.fromEntries(
        formConfig.map(
          (item) => MapEntry(item.fieldname!, item),
        ),
      );

      if (formConfigMap.containsKey("categorypath")) {
        formConfigMap["categorypath"]?.defaultValue = state.category?.path;
      }
      if (formConfigMap.containsKey("categoryname")) {
        formConfigMap["categoryname"]?.defaultValue = state.category?.name;
      }

      if (formConfigMap.containsKey("user")) {
        formConfigMap["user"]?.defaultValue =
            FirebaseAuth.instance.currentUser?.phoneNumber;
      }

      if (formConfigMap.containsKey("productid")) {
        formConfigMap["productid"]?.defaultValue = state.selectedProduct?.id;
      }

      Map<String, FormConfig> newFormConfigMap = {
        ...state.formConfigMap,
        ...formConfigMap
      };

      for (var entry in newFormConfigMap.values) {
        FormConfig config = entry;
        if (config.rules != null &&
            config.rules is List &&
            config.rules.length > 0) {
          for (var rule in config.rules) {
            switch (rule["type"]) {
              case "hide":
                String? fieldToWatch = rule["fieldtowatch"];
                String? operator = rule["operator"];
                String? val = rule["value"];
                print(newFormConfigMap.containsKey(fieldToWatch.toString()));
                if (newFormConfigMap.containsKey(fieldToWatch.toString())) {
                  if (operator == "isequalto") {
                    if (val ==
                        newFormConfigMap[fieldToWatch]
                            ?.defaultValue
                            .toString()) {
                      config.hidden = false;
                    }
                  }
                }
            }
          }
        }
      }

      emit(state.copyWith(
          formConfig: newFormConfigMap.values.toList(),
          formConfigMap: newFormConfigMap,
          isLoading: false,
          lastDocument: lastDocument));
    } catch (e) {
      print("*****can not load form due to error ==$e");
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onFieldChanged(FieldChanged event, Emitter<FormState> emit) {
    try {
      final fieldName = event.fieldKey; //incoming field value
      final value = event.value; //incoming value
      final config = state.formConfigMap[fieldName]; //config for incoming field
      final errorState = Map<String, dynamic>.from(state.errors);

      if (config == null) return;

      Map<String, FormConfig> updatedMap = Map<String, FormConfig>.from(
          state.formConfigMap); //take a copy of current formConfigMap
      // final updatedField = config.copyWith(defaultValue: value);
      // updatedMap[fieldName] = updatedField;

      if (config.required) {
        final valueString = value?.toString() ?? "";
        if (valueString.trim().isEmpty) {
          errorState[fieldName] = "This field is required";
        } else {
          errorState[fieldName] = null;
        }
      }

      if (config.datatype == "number" ||
          config.datatype == "double" ||
          config.datatype == "int") {
        final resultNum = num.tryParse(value?.toString() ?? '');
        print("I am resultnum===>$resultNum and fieldName=$fieldName");

        if (resultNum == null) {
          errorState[fieldName] = "Not a valid number";
          print(errorState[fieldName]);
        } else {
          errorState[fieldName] = null;
        }
      }
      final updatedField = config.copyWith(defaultValue: value);
      updatedMap[fieldName] = updatedField;
      if (config.rules != null &&
          config.rules is List &&
          config.rules.length > 0) {
        for (var rule in config.rules) {
          if (rule["type"] == "calculate") {
            String? dumpsTo = rule["dumpsto"];
            String? e = rule["expression"];
            Map<String, dynamic> eb = rule["expressionbuilder"];

            Map<String, double?> peb = eb.map((k, v) {
              if (v == "value") {
                return MapEntry(k, double.tryParse(value.toString()));
              } else {
                if (updatedMap.containsKey(v.toString()) &&
                    updatedMap[v.toString()]?.defaultValue != null &&
                    updatedMap[v.toString()]?.defaultValue != 0 &&
                    updatedMap[v.toString()]?.defaultValue != "0") {
                  return MapEntry(
                      k,
                      double.tryParse(
                              updatedMap[v.toString()]?.defaultValue ?? '0') ??
                          0.0);
                } else {
                  return MapEntry(k, null);
                }
              }
            });
            print(peb);
            Parser p = Parser();
            final cm = ContextModel();
            final exp = p.parse(e!);
            for (var entry in peb.entries) {
              cm.bindVariable(Variable(entry.key), Number(entry.value ?? 0));
            }
            final result = exp.evaluate(EvaluationType.REAL, cm);

            updatedMap[dumpsTo.toString()] =
                updatedMap[dumpsTo.toString()]!.copyWith(defaultValue: result);
          }
          if (rule["type"] == "copyto") {
            print("copyto");
            String copyToField = rule["copytofield"];
            updatedMap[copyToField.toString()] =
                updatedMap[copyToField.toString()]!
                    .copyWith(defaultValue: value);
          }
        }
      }

      emit(state.copyWith(
        formConfigMap: updatedMap,
        errors: errorState,
      ));
    } catch (e) {
      print(e);
    }

    // }

    // if (config.datatype == "string" || config.datatype == "text") {
    //   if (value is! String) {
    //     errorState[fieldName] = "not a valid string";
    //   }
    // }

    // Only process the value if it's not null or empty
    // if (value != null && value.toString().trim().isNotEmpty) {
    //   final typedValue = _getDataTypeForAttribute(config.datatype, value);

    //   bool hasError = typedValue.error != null;

    //   if (hasError) {
    //     errorState[fieldName] = typedValue.error;
    //   } else {
    //     errorState[fieldName] = null;
    //     final updatedField = config.copyWith(defaultValue: typedValue.result);
    //     updatedMap[fieldName] = updatedField;
    //   }
    // } else {
    //   // Handle empty values differently - don't update the field value immediately
    //   if (config.required) {
    //     errorState[fieldName] = "This is a required field";
    //   } else if (!config.required) {
    //     errorState[fieldName] = null;
    //     // Only clear the value if t  he field is not required
    //     final updatedField = config.copyWith(
    //         defaultValue: _getDefaultValueForType(config.datatype));
    //     updatedMap[fieldName] = updatedField;
    //   }
    // }

    // Reevaluation rules (e.g. hide/show other fields)
    // if (config.reevaluate != null &&
    //     config.reevaluate is List &&
    //     config.reevaluate.length > 0) {
    //   for (var rev in config.reevaluate) {
    //     if (rev["type"] == "hide") {
    //       String? forField = rev["forfield"];
    //       if (updatedMap.containsKey(forField)) {
    //         FormConfig? reevaluatedConfig = updatedMap[forField];
    //         if (reevaluatedConfig != null &&
    //             reevaluatedConfig.rules != null &&
    //             reevaluatedConfig.rules.isNotEmpty) {
    //           for (var rule in reevaluatedConfig.rules) {
    //             if (rule["type"] == "hide") {
    //               String? fieldToWatch = rule["fieldtowatch"];
    //               String? operator = rule["operator"];
    //               String? val = rule["value"];
    //               if (updatedMap.containsKey(fieldToWatch)) {
    //                 final watchedValue =
    //                     updatedMap[fieldToWatch]?.defaultValue?.toString() ??
    //                         '';

    //                 if (operator == "isequalto") {
    //                   final shouldHide = !(value.toString() == val.toString());
    //                   updatedMap[forField!] =
    //                       reevaluatedConfig.copyWith(hidden: shouldHide);
    //                 }
    //               }
    //             }
    //           }
    //         }
    //       }
    //     }
    //     if (rev["type"] == "discount") {
    //       String? forField = rev["forfield"];
    //       if (updatedMap.containsKey(forField)) {
    //         FormConfig? reevaluateConfig = updatedMap[forField];
    //         if (reevaluateConfig != null &&
    //             reevaluateConfig.rules != null &&
    //             reevaluateConfig.rules.isNotEmpty) {
    //           for (var rule in reevaluateConfig.rules) {
    //             if (rule["type"] == "discount") {
    //               String? fieldToWatch = rule["fieldtowatch"];
    //               String? operator = rule["operator"];
    //               String? discountfield = rule["discountfield"];

    //               if (updatedMap.containsKey(fieldToWatch) &&
    //                   updatedMap.containsKey(discountfield)) {
    //                 final watchedValue = updatedMap[fieldToWatch]?.defaultValue;
    //                 final discount = updatedMap[discountfield]?.defaultValue;
    //                 if (operator == "discount-minus" &&
    //                     watchedValue != null &&
    //                     discount != null) {
    //                   if (watchedValue != null && discount != null) {
    //                     print("field to watch ===>${watchedValue}");
    //                     double result = double.parse(watchedValue) -
    //                         (double.parse(discount) /
    //                             100 *
    //                             double.parse(watchedValue));
    //                     updatedMap[forField!] =
    //                         reevaluateConfig.copyWith(defaultValue: result);
    //                   }
    //                 }
    //               }
    //             }
    //           }
    //         }
    //       }
    //     }
    //   }
    // }
  }

  ({dynamic result, String? error}) _getDataTypeForAttribute(
      String? datatype, String fieldName) {
    switch (datatype) {
      case 'string':
      case 'text':
        return (result: fieldName.toString(), error: null);

      case 'int':
        final intValue = int.tryParse(fieldName);
        if (intValue == null) {
          return (result: null, error: "Invalid integer");
        }
        return (result: intValue, error: null);

      case 'double':
        final doubleValue = double.tryParse(fieldName);
        if (doubleValue == null) {
          return (result: null, error: "Invalid double");
        }
        return (result: doubleValue, error: null);

      case 'bool':
        final normalized = fieldName.toLowerCase().trim();
        if (normalized == 'true') return (result: true, error: null);
        if (normalized == 'false') return (result: false, error: null);
        return (result: null, error: "Invalid boolean");

      // case 'array<string>':
      //   return (result: fieldName, error: null);

      default:
        return (result: null, error: "Unsupported data type: '$datatype'");
    }
  }

  Map<String, String?> _validateAllFields(
      Map<String, dynamic> values, List<FormConfig> configs) {
    final errors = <String, String?>{};
    for (var config in configs) {
      // Only validate visible fields
      if (!config.hidden) {
        errors[config.fieldname!] =
            _validateField(config, values[config.fieldname!]);
      } else {
        errors[config.fieldname!] = null; // No error for hidden fields
      }
    }
    return errors;
  }

  String? _validateField(FormConfig config, dynamic value) {
    // Pass FormConfig directly
    if (config.hidden) return null;
    String stringValue;
    if (value is String) {
      stringValue = value;
    } else if (value is List &&
        value.isEmpty &&
        config.datatype == 'array<string>') {
      // For arrays, empty means no elements.
      if (config.required) return "This field is required";
      return null; // Empty array but not required is fine
    } else if (value != null) {
      stringValue = value.toString(); // For int, double, bool
    } else {
      stringValue = ""; // If value is null
    }

    if (config.required && stringValue.isEmpty) {
      if (config.datatype == 'array<string>' &&
          (value == null || (value is List && value.isEmpty))) {
        return "This field is required";
      } else if (config.datatype != 'array<string>' && stringValue.isEmpty) {
        return "This field is required";
      }
    }

    if (config.datatype == 'int') {
      if (value != null &&
          value.toString().isNotEmpty &&
          int.tryParse(value.toString()) == null) {
        return "Must be a valid integer";
      }
    } else if (config.datatype == 'double') {
      if (value != null &&
          value.toString().isNotEmpty &&
          double.tryParse(value.toString()) == null) {
        return "Must be a valid number";
      }
    }

    return null;
  }

  dynamic _getDefaultValueForType(String? datatype) {
    switch (datatype) {
      case 'string':
      case 'text': // Assuming 'text' display means string data
      case 'textarea':
        return "";
      case 'int':
        return 0;
      case 'double':
        return 0.0;
      case 'bool':
        return false;
      case 'array<string>':
        return <String>[];
      // Add other types as needed
      default:
        return ""; // Default fallback
    }
  }

  Future<void> _onFormSave(FormSave event, Emitter<FormState> emit) async {
    try {
      emit(state.copyWith(creatingProduct: true));
      Map<String, dynamic> highlights = {};
      Map<String, dynamic> info = {};
      Map<String, dynamic> productSection = {};
      Map<String, dynamic> variationSection = {};
      Map<String, dynamic> inventory = {};
      List<Map<String, dynamic>> variationList = [];

      List<String> imageURLList = [];
      Map<String, dynamic> formDataToSave = {};
      String? categoryPath = state.formConfigMap["categorypath"]?.defaultValue;
      String? categoryName = state.formConfigMap["categoryname"]?.defaultValue;

      if (forEntity == "newproduct") {
        if (categoryPath == null || categoryName == null) {
          emit(state.copyWith(error: "Category is empty"));
          return;
        }
      }

      //check for empty value
      // Map<String, dynamic> createFinalErrorMap = {};
      // for (var entry in state.formConfigMap.entries) {
      //   if (entry.value.required) {
      //     if (entry.value.defaultValue.toString().isEmpty) {
      //       createFinalErrorMap[entry.key] = "This is a required field";
      //     } else {
      //       final typeError = _getDataTypeForAttribute(
      //           entry.value.datatype, entry.value.defaultValue.toString());
      //       if (typeError.error != null) {
      //         createFinalErrorMap[entry.key] = typeError.error;
      //       }
      //     }
      //   } else {
      //     final typeValueNRF = _getDataTypeForAttribute(
      //         entry.value.datatype, entry.value.defaultValue.toString());
      //     if (typeValueNRF.error != null) {
      //       createFinalErrorMap[entry.key] = typeValueNRF.error;
      //     }
      //   }
      // }

      if (state.productImages.isNotEmpty) {
        ImageUploader uploader = ImageUploader(
            entityList: state.productImages, fileName: categoryName.toString());
        imageURLList = await uploader.upload();
      }

      // image processing
      // if (state.productImages.isNotEmpty) {
      //   for (XFile file in state.productImages) {
      //     File imageFile = File(file.path);
      //     String fileName = "$categoryName/${file.name}";
      //     Reference storageRef =
      //         FirebaseStorage.instance.ref().child("images/$fileName.jpg");
      //     UploadTask uploadTask = storageRef.putFile(imageFile);
      //     TaskSnapshot taskSnap = await uploadTask;
      //     String imageURL = await taskSnap.ref.getDownloadURL();
      //     if (imageURL.isEmpty) {
      //       throw Exception("Error in image uploading");
      //     }
      //     imageURLList.add(imageURL.toString());
      //   }
      //   if (imageURLList.isEmpty) {
      //     throw Exception("Error in image uploading");
      //   }
      // }

      // createFinalErrorMap.remove("images");

      // if (createFinalErrorMap.values.isNotEmpty) {
      //   emit(state.copyWith(error: "Error in saveving form"));
      // } else {
      //   for (FormConfig config in state.formConfigMap.values) {
      //     createFinalErrorMap[config.fieldname!] = config.defaultValue;
      //   }
      // }
      // createFinalErrorMap = {...createFinalErrorMap, "images": imageURLList};

      //***************************
      for (var config in state.formConfigMap.entries) {
        if (config.value.section.contains("product")) {
          productSection[config.key] = config.value.defaultValue;
        }
        if (config.value.section.contains("variation")) {
          variationSection[config.key] = config.value.defaultValue;
        }

        if (config.value.section.contains("highlight")) {
          highlights[config.key] = config.value.defaultValue;
        }
        if (config.value.section.contains("info")) {
          info[config.key] = config.value.defaultValue;
        }
        if (config.value.section.contains("inventory")) {
          inventory[config.key] = config.value.defaultValue;
        }
      }

      if (imageURLList.isEmpty) {
        throw Exception("No image selected");
      }

      Map<String, dynamic> productWithExtrainformation = {
        ...productSection,
        "highlights": highlights,
        "info": info
      };

      //variation // this will go in variation collection
      Map<String, dynamic> v = {
        ...variationSection,
        "images": imageURLList,
        "productid": state.selectedProduct?.id,
      };

      // Productt prod = Productt.fromMap(productWithExtrainformation);
      Variation variation = Variation.fromMap(v);
      Inventory inv = Inventory.fromMap(inventory);
      FirebaseFirestore fireStore = dbService.getFireStore();

      // if (forEntity == "newproduct") {
      //   await transactionForNewProductCreation(fireStore, prod, variation, inv);
      // }

      print("*********selected productid*********************");
      print(state.selectedProduct?.id);
      print("*********selected product id********************");

      if (forEntity == "newvariation") {
        await transactionForVariationCreation(fireStore, variation, inv);
      }

      // await fireStore.runTransaction((transaction) async {
      //   Map<String, dynamic> productMap = prod.toMap();
      //   productMap.remove("id");
      //   Map<String, dynamic> variationMap = variation.toMap();
      //   variationMap.remove("id");
      //   Map<String, dynamic> inventoryMap = inv.toMap();
      //   inventoryMap.remove("id");
      //   final productId = fireStore.collection("products").doc().id;
      //   final productRef = fireStore
      //       .collection('products')
      //       .doc(productId); // get the product id
      //   //setting product
      //   transaction.set(productRef, productMap);
      //   //set variations
      //   final variationId = fireStore.collection("variations").doc().id;
      //   final variationRef = fireStore
      //       .collection("products")
      //       .doc(productRef.id)
      //       .collection("variations")
      //       .doc(variationId);
      //   transaction
      //       .set(variationRef, {...variationMap, "productId": productRef.id});

      //   //set variation globaly
      //   final globalVariationRef =
      //       fireStore.collection("variations").doc(variationId);
      //   transaction.set(globalVariationRef, inventoryMap);
      //   //set inventory
      //   final inventoryRef = fireStore.collection("inventory").doc();
      //   transaction
      //       .set(inventoryRef, {"variationid": variationId, ...inv.toMap()});
      // });

      emit(state.copyWith(creatingProduct: false));
    } catch (error, stk) {
      print(error);
      print(stk);
      emit(state.copyWith(creatingProduct: false, error: error.toString()));
    } finally {
      emit(state.copyWith(creatingProduct: false));
    }
  }

  Future<void> _itemCreated(ItemCreated event, Emitter<FormState> emit) async {
    emit(state.copyWith(isLoading: true));
  }
}

Future<void> transactionForVariationCreation(FirebaseFirestore fireStore,
    Variation variation, Inventory inventory) async {
  if (variation.productId == null || variation.productId == "") {
    return;
  }

  final productId = variation.productId;
  await fireStore.runTransaction((transaction) async {
    Map<String, dynamic> variationMap = variation.toMap();
    Map<String, dynamic> inventoryMap = inventory.toMap();
    variationMap.remove("id");
    inventoryMap.remove("id");
    // variation creation
    final variationId = fireStore.collection("variation").doc().id;
    final variationRef = fireStore
        .collection("products")
        .doc(productId)
        .collection("variations")
        .doc(variationId);
    transaction.set(variationRef, variationMap);
    //**************************************************** */

    //inventory creation
    final inventoryRef = fireStore.collection("inventory").doc();
    transaction
        .set(inventoryRef, {"variationid": variationId, ...inventoryMap});

    //************************************ */

    // add variation to related product
  });
}

Future<void> transactionForNewProductCreation(FirebaseFirestore fireStore,
    Productt product, Variation variation, Inventory inventory) async {
  await fireStore.runTransaction((transaction) async {
    Map<String, dynamic> productMap = product.toMap();
    Map<String, dynamic> variationMap = variation.toMap();
    Map<String, dynamic> inventoryMap = inventory.toMap();
    productMap.remove("id");
    variationMap.remove("id");
    inventoryMap.remove("id");
    // product creation
    final productId = fireStore.collection("products").doc().id;
    final productRef = fireStore.collection("products").doc(productId);
    transaction.set(productRef, productMap);
    //****************************************** */

    //variation creation
    final variationId = fireStore.collection("variations").doc().id;
    final variationRef = fireStore
        .collection("products")
        .doc(productRef.id)
        .collection("variations")
        .doc(variationId);
    transaction
        .set(variationRef, {...variationMap, "productId": productRef.id});
    //************************************************ */

    //Global variation creation
    final globalVariationRef =
        fireStore.collection("variations").doc(variationId);
    transaction.set(globalVariationRef, inventoryMap);
    /******************************************************************* */

    //Inventory creation
    final inventoryRef = fireStore.collection("inventory").doc();
    transaction
        .set(inventoryRef, {"variationid": variationId, ...inventoryMap});
  });
}

class ImageUploader {
  List<XFile> entityList;
  String fileName;

  ImageUploader({required this.entityList, required this.fileName});

  Future<List<String>> upload() async {
    List<String> imageUrlList = [];
    for (XFile file in entityList) {
      File imageFile = File(file.path);
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child("images/$fileName/${file.name}.jpg");
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnap = await uploadTask;
      String uploadedImageUrl = await taskSnap.ref.getDownloadURL();
      if (uploadedImageUrl.isEmpty) {
        throw Exception("Error in image uploading");
      }
      imageUrlList.add(uploadedImageUrl);
    }
    return imageUrlList;
  }
}
