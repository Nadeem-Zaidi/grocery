part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final bool loading;
  final PageBuilder page;
  final List<Section> sectionToSave;
  final String? error;
  final double promoBannerVerticalPosition;

  const DashboardState(
      {this.loading = false,
      this.error,
      this.sectionToSave = const [],
      required this.page,
      required this.promoBannerVerticalPosition});

  factory DashboardState.initial() {
    return DashboardState(
      page: PageBuilder(
        appbarHeight: 50,
      ),
      promoBannerVerticalPosition: 50, // provide a default Dashboard
    );
  }

  DashboardState copyWith(
      {bool? loading,
      Map<String, Section>? sections,
      String? error,
      PageBuilder? page,
      List<Section>? sectionToSave,
      Map<String, Section>? promoBanner,
      double? promoBannerVerticalPosition}) {
    return DashboardState(
      loading: loading ?? this.loading,
      page: page ?? this.page,
      error: error ?? this.error,
      sectionToSave: sectionToSave ?? this.sectionToSave,
      promoBannerVerticalPosition:
          promoBannerVerticalPosition ?? this.promoBannerVerticalPosition,
    );
  }

  @override
  List<Object?> get props =>
      [loading, error, sectionToSave, page, promoBannerVerticalPosition];
}
