part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final bool loading;
  final PageBuilder page;
  final Map<String, Section> sections;
  final Map<String, Section> promoBanner;
  final List<Section> sectionToSave;
  final String? error;

  const DashboardState({
    this.sections = const {},
    this.promoBanner = const {},
    this.loading = false,
    this.error,
    this.sectionToSave = const [],
    required this.page,
  });

  factory DashboardState.initial() {
    return DashboardState(
      page: PageBuilder(), // provide a default Dashboard
    );
  }

  DashboardState copyWith({
    bool? loading,
    Map<String, Section>? sections,
    String? error,
    PageBuilder? page,
    List<Section>? sectionToSave,
    Map<String, Section>? promoBanner,
  }) {
    return DashboardState(
        loading: loading ?? this.loading,
        sections: sections ?? this.sections,
        page: page ?? this.page,
        error: error ?? this.error,
        sectionToSave: sectionToSave ?? this.sectionToSave,
        promoBanner: promoBanner ?? this.promoBanner);
  }

  @override
  List<Object?> get props =>
      [sections, loading, error, sectionToSave, page, promoBanner];
}
