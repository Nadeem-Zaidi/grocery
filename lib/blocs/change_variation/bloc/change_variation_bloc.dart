import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'change_variation_event.dart';
part 'change_variation_state.dart';

class ChangeVariationBloc
    extends Bloc<ChangeVariationEvent, ChangeVariationState> {
  ChangeVariationBloc() : super(ChangeVariationState.initial()) {
    on<ChangeVariationEvent>((event, emit) async {
      switch (event) {
        case ChangeVariation(variationId: String v):
          _changeVariation(emit, v);
      }
    });
  }
  void _changeVariation(
      Emitter<ChangeVariationState> emit, String variationId) {
    emit(state.copyWith(variationId: variationId));
  }
}
