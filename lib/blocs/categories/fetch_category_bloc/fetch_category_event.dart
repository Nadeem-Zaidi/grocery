part of 'fetch_category_bloc.dart';

@immutable
sealed class FetchCategoryEvent {}

class FetchCategories extends FetchCategoryEvent {
  FetchCategories();
}

@immutable
class FetchCategoryChildren extends FetchCategoryEvent {
  final String categoryId;
  final String categoryName;
  FetchCategoryChildren(this.categoryId, this.categoryName);
}

@immutable
class FetchProductWithChildren extends FetchCategoryEvent {
  FetchProductWithChildren();
}

@immutable
class SetCurrentChild extends FetchCategoryEvent {
  final String name;
  SetCurrentChild(this.name);
}

@immutable
class SelectProductCategory extends FetchCategoryEvent {
  final Category category;
  SelectProductCategory(this.category);
}

@immutable
class ProductWithCategory extends FetchCategoryEvent {
  final String name;
  ProductWithCategory(this.name);
}

class FetchNext extends FetchCategoryEvent {}
