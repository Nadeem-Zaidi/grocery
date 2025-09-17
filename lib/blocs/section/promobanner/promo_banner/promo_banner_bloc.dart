import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_app/database_service.dart/dashboard/section.dart';

part 'promo_banner_event.dart';
part 'promo_banner_state.dart';

class PromoBannerBloc extends Bloc<PromoBannerEvent, PromoBannerState> {
  PromoBannerBloc() : super(PromoBannerState()) {
    on<PromoBannerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
