part of 'category_create_bloc.dart';

@immutable
class CreateCategoryState {
  final List<dynamic> categories; // Changed to List<dynamic>
  final String? name;
  final bool isLoading;
  final String? error;
  final File? imageFile;
  final String? uploadedUrl;
  final String? path;
  final String? fixedPath;
  final String? parentId;

  CreateCategoryState({
    this.error,
    required this.categories, // Now required
    required this.name,
    required this.isLoading,
    this.imageFile,
    this.uploadedUrl,
    this.path,
    this.fixedPath,
    this.parentId,
  });

  factory CreateCategoryState.initial() {
    return CreateCategoryState(
      error: null,
      categories: [], // Initialize as an empty list
      name: null,
      isLoading: false,
      imageFile: null,
      uploadedUrl: null,
      path: "",
      fixedPath: "",
      parentId: null,
    );
  }

  CreateCategoryState copyWith({
    List<dynamic>? categories, // Updated to List<dynamic>
    String? name,
    bool? isLoading,
    String? error,
    File? imageFile,
    String? uploadedUrl,
    String? path,
    String? fixedPath,
    String? parentId,
  }) {
    return CreateCategoryState(
      categories: categories ?? this.categories,
      name: name ?? this.name,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      imageFile: imageFile ?? this.imageFile,
      uploadedUrl: uploadedUrl ?? this.uploadedUrl,
      path: path ?? this.path,
      fixedPath: fixedPath ?? this.fixedPath,
      parentId: parentId ?? this.parentId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreateCategoryState &&
        listEquals(other.categories, categories) && // Compare lists
        other.name == name &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.imageFile == imageFile &&
        other.uploadedUrl == uploadedUrl &&
        other.path == path &&
        other.fixedPath == fixedPath &&
        other.parentId == parentId;
  }

  @override
  int get hashCode {
    return categories.hashCode ^
        name.hashCode ^
        isLoading.hashCode ^
        error.hashCode ^
        imageFile.hashCode ^
        uploadedUrl.hashCode ^
        path.hashCode ^
        fixedPath.hashCode ^
        parentId.hashCode;
  }

  @override
  String toString() {
    return 'CategoryState(categories: $categories, name: $name, isLoading: $isLoading, path: $path)';
  }
}
