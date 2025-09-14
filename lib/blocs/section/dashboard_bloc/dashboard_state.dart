part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final bool loading;
  final Dashboard dashBoard;
  final Map<String, Section> sections;
  final List<Section> sectionToSave;
  final String? error;

  const DashboardState(
      {this.sections = const {},
      this.loading = false,
      this.error,
      this.sectionToSave = const [],
      required this.dashBoard});

  factory DashboardState.initial() {
    return DashboardState(
      dashBoard: Dashboard(), // provide a default Dashboard
    );
  }

  DashboardState copyWith(
      {bool? loading,
      Map<String, Section>? sections,
      String? error,
      Dashboard? dashBoard,
      List<Section>? sectionToSave}) {
    return DashboardState(
        loading: loading ?? this.loading,
        sections: sections ?? this.sections,
        dashBoard: dashBoard ?? this.dashBoard,
        error: error ?? this.error,
        sectionToSave: sectionToSave ?? this.sectionToSave);
  }

  @override
  List<Object?> get props =>
      [sections, loading, error, sectionToSave, dashBoard];
}
