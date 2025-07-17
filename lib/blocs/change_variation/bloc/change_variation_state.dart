part of 'change_variation_bloc.dart';

class ChangeVariationState extends Equatable {
  final String? variationId;

  const ChangeVariationState({this.variationId});

  factory ChangeVariationState.initial() {
    return const ChangeVariationState(variationId: null);
  }

  ChangeVariationState copyWith({String? variationId}) {
    return ChangeVariationState(
      variationId: variationId ?? this.variationId,
    );
  }

  @override
  List<Object?> get props => [variationId];
}
