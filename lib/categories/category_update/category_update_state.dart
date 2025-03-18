part of 'category_update_bloc.dart';

@immutable
class CategoryUpdateState {
  String? id;
  Category? category;
  final bool isFetching;
  String? error;
  String? existingName;
  String? existingPath;
  String? existingParent;
  String? nameToUpdate;
  String? pathToUpdate;
  String? parentToUpdate;
  File? imageFile;
  String? uploadedImage;

  CategoryUpdateState(
      {this.id,
      this.category,
      this.isFetching = false,
      this.error,
      this.existingName,
      this.existingPath,
      this.existingParent,
      this.nameToUpdate,
      this.parentToUpdate,
      this.pathToUpdate,
      this.imageFile,
      this.uploadedImage});

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
        parentToUpdate: null,
        pathToUpdate: null,
        imageFile: null,
        uploadedImage: null);
  }

  CategoryUpdateState copyWith({
    String? id,
    Category? category,
    bool? isFetching,
    String? error,
    String? existingName,
    String? existingPath,
    String? existingParent,
    String? nameToUpdate,
    String? pathToUpdate,
    String? parentToUpdate,
    File? imageFile,
    String? uploadedImage,
  }) {
    return CategoryUpdateState(
        id: id ?? this.id,
        category: category ?? this.category,
        isFetching: isFetching ?? this.isFetching,
        error: error ?? this.error,
        existingName: existingName ?? this.existingName,
        existingParent: existingParent ?? this.existingParent,
        existingPath: existingPath ?? this.existingPath,
        nameToUpdate: nameToUpdate ?? this.nameToUpdate,
        pathToUpdate: pathToUpdate ?? this.parentToUpdate,
        parentToUpdate: parentToUpdate ?? this.parentToUpdate,
        imageFile: imageFile ?? this.imageFile,
        uploadedImage: uploadedImage ?? this.uploadedImage);
  }
}
