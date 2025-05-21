part of 'fetch_category_bloc.dart';

@immutable
sealed class FetchCategoryEvent {}

class FetchCategories extends FetchCategoryEvent {
  FetchCategories();
}

class FetchCategoryChildren extends FetchCategoryEvent {
  String categoryId;
  String categoryName;
  FetchCategoryChildren(this.categoryId, this.categoryName);
}

class FetchProductWithChildren extends FetchCategoryEvent {
  FetchProductWithChildren();
}

class SetCurrentChild extends FetchCategoryEvent {
  String name;
  SetCurrentChild(this.name);
}

class FetchNext extends FetchCategoryEvent {}
