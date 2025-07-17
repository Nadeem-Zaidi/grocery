part of 'change_variation_bloc.dart';

sealed class ChangeVariationEvent extends Equatable {
  const ChangeVariationEvent();

  @override
  List<Object> get props => [];
}

class ChangeVariation extends ChangeVariationEvent {
  final String variationId;
  const ChangeVariation({required this.variationId});
}
