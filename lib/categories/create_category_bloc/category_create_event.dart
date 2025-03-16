part of 'category_create_bloc.dart';

@immutable
sealed class CreateCategoryEvent {}

// class FetchAllCategories extends CategoryEvent {
//   final List<category.Category>? categories;
//   FetchAllCategories({this.categories});
// }

// class FetchCategory extends CategoryEvent {
//   final String categoryId;
//   FetchCategory({required this.categoryId});
// }

class PickImage extends CreateCategoryEvent {
  PickImage();
}

// class SetName extends CategoryEvent {
//   final String name;
//   SetName({required this.name});
// }

class Setpath extends CreateCategoryEvent {
  final String fixed;
  final String parentId;

  Setpath({required this.fixed, required this.parentId});
}

class UpdateCategoryPath extends CreateCategoryEvent {
  final String userInput;
  UpdateCategoryPath({required this.userInput});
}

class ResetPatg extends CreateCategoryEvent {}

class CreateCategory extends CreateCategoryEvent {
  CreateCategory();
}
