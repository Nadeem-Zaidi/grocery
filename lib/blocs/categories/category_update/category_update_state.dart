part of 'category_update_bloc.dart';

@immutable
class CategoryUpdateState {
  String? id;
  Category? category;
  final bool isFetching;
  String? error;
  String? existingName;
  String? existingPath;
  String? pathName;
  String? existingParent;
  String? nameToUpdate;

  File? imageFile;
  String? uploadedImage;
  bool? shouldChange;
  String? fixedPath;
  String? dynamicPath;
  final bool done;

  CategoryUpdateState({
    this.id,
    this.category,
    this.isFetching = false,
    this.error,
    this.existingName,
    this.existingPath,
    this.existingParent,
    this.nameToUpdate,
    this.imageFile,
    this.uploadedImage,
    this.shouldChange = false,
    this.fixedPath,
    this.dynamicPath,
    this.pathName,
    this.done = false,
  });

  factory CategoryUpdateState.initial() {
    return CategoryUpdateState(
        id: null,
        category: null,
        isFetching: false,
        error: null,
        existingName: null,
        existingPath: null,
        existingParent: null,
        nameToUpdate: null,
        imageFile: null,
        uploadedImage: null,
        shouldChange: false,
        fixedPath: null,
        dynamicPath: null,
        pathName: null,
        done: false);
  }

  CategoryUpdateState copyWith(
      {String? id,
      Category? category,
      bool? isFetching,
      String? error,
      String? existingName,
      String? existingPath,
      String? existingParent,
      File? imageFile,
      String? uploadedImage,
      bool? shouldChange,
      String? fixedPath,
      String? dynamicPath,
      String? pathName,
      bool? done}) {
    return CategoryUpdateState(
        id: id ?? this.id,
        category: category ?? this.category,
        isFetching: isFetching ?? this.isFetching,
        error: error ?? this.error,
        existingName: existingName ?? this.existingName,
        existingParent: existingParent ?? this.existingParent,
        existingPath: existingPath ?? this.existingPath,
        nameToUpdate: nameToUpdate ?? nameToUpdate,
        imageFile: imageFile ?? this.imageFile,
        uploadedImage: uploadedImage ?? this.uploadedImage,
        shouldChange: shouldChange ?? this.shouldChange,
        fixedPath: fixedPath ?? this.fixedPath,
        dynamicPath: dynamicPath ?? this.dynamicPath,
        pathName: pathName ?? this.pathName,
        done: done ?? this.done);
  }
}
