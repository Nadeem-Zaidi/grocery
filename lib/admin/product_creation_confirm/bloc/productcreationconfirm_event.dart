part of 'productcreationconfirm_bloc.dart';

sealed class ProductCreationConfirmEvent extends Equatable {
  const ProductCreationConfirmEvent();

  @override
  List<Object> get props => [];
}

class ProductCreated extends ProductCreationConfirmEvent {
  final String id;
  const ProductCreated({required this.id});
}
