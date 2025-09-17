part of 'promo_banner_bloc.dart';

class PromoBannerState extends Equatable {
  final bool loading;
  final Section? section;
  final String? error;

  const PromoBannerState({this.loading = false, this.section, this.error});

  factory PromoBannerState.initial() => PromoBannerState();

  PromoBannerState copyWith({bool? loading, Section? section, String? error}) {
    return PromoBannerState(
      loading: loading ?? this.loading,
      section: section ?? this.section,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [loading, section, error];
}

final class PromoBannerInitial extends PromoBannerState {}
