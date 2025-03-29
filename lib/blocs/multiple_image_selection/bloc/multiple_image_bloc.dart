import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'multiple_image_event.dart';
part 'multiple_image_state.dart';

class MultipleImageBloc extends Bloc<MultipleImageEvent, MultipleImageState> {
  MultipleImageBloc() : super(MultipleImageInitial()) {
    on<MultipleImageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
