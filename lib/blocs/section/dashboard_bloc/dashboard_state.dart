part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final bool loading;
  final PageBuilder page;

  final List<Section> sectionToSave;
  final String? error;

  const DashboardState({
    this.loading = false,
    this.error,
    this.sectionToSave = const [],
    required this.page,
  });

  factory DashboardState.initial() {
    return DashboardState(
      page: PageBuilder(appbarHeight: 600), // provide a default Dashboard
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
        page: page ?? this.page,
        error: error ?? this.error,
        sectionToSave: sectionToSave ?? this.sectionToSave);
  }

  @override
  List<Object?> get props => [loading, error, sectionToSave, page];
}
