part of 'category_bloc.dart';

@immutable
sealed class CategoryEvent {}

class FetchAllCategories extends CategoryEvent {
  List<category.Category>? categories;
  FetchAllCategories({this.categories});
}

class FetchCategory extends CategoryEvent {
  final String categoryId;
  FetchCategory({required this.categoryId});
}

class CreateCategory extends CategoryEvent {
  Map<String, dynamic> categoryData;
  CreateCategory({required this.categoryData});
}
