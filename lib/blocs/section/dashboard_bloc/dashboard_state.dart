part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final bool loading;
  final List<Section> sections;
  final List<Section> sectionToSave;
  final String? error;

  const DashboardState(
      {this.sections = const [],
      this.loading = false,
      this.error,
      this.sectionToSave = const []});

  const DashboardState.initial() : this();

  DashboardState copyWith(
      {bool? loading,
      List<Section>? sections,
      String? error,
      List<Section>? sectionToSave}) {
    return DashboardState(
        loading: loading ?? this.loading,
        sections: sections ?? this.sections,
        error: error ?? this.error,
        sectionToSave: sectionToSave ?? this.sectionToSave);
  }

  @override
  List<Object?> get props => [sections, loading, error, sectionToSave];
}
