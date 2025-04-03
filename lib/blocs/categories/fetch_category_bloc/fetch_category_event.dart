part of 'fetch_category_bloc.dart';

@immutable
sealed class FetchCategoryEvent {}

class FetchCategories extends FetchCategoryEvent {
  FetchCategories();
}

class FetchCategoryChildren extends FetchCategoryEvent {
  String categoryId;
  FetchCategoryChildren(this.categoryId);
}
