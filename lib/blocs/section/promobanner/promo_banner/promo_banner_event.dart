part of 'promo_banner_bloc.dart';

sealed class PromoBannerEvent extends Equatable {
  const PromoBannerEvent();

  @override
  List<Object> get props => [];
}

class AddContent extends PromoBannerEvent {}
