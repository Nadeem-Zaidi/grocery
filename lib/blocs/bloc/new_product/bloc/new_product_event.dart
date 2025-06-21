part of 'new_product_bloc.dart';

sealed class NewProductEvent extends Equatable {
  const NewProductEvent();

  @override
  List<Object> get props => [];
}

class FetchCategoriesForNewProduct extends NewProductEvent {}

@immutable
class NewProductSelectCategoryEvent extends NewProductEvent {
  final cat.Category category;
  const NewProductSelectCategoryEvent({required this.category});

  @override
  List<Object> get props => [category];
}
