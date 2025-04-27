part of 'dashboard_builder_cubit.dart';

@immutable
class DashboardBuilderState {
  final List<Section> sections;
  final bool isLoading;
  final String? error;
  final DocumentSnapshot? lastDocument;
  final bool hasReachedMax;

  const DashboardBuilderState({
    required this.sections,
    required this.isLoading,
    this.error,
    this.lastDocument,
    this.hasReachedMax = false,
  });

  factory DashboardBuilderState.initial() {
    return const DashboardBuilderState(
        sections: [], isLoading: false, hasReachedMax: false);
  }

  DashboardBuilderState copyWith({
    List<Section>? sections,
    bool? isLoading,
    String? error,
    DocumentSnapshot? lastDocument,
    bool? hasReachedMax,
  }) {
    return DashboardBuilderState(
        sections: sections ?? this.sections,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        lastDocument: lastDocument ?? this.lastDocument,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DashboardBuilderState &&
        listEquals(other.sections, sections) &&
        other.isLoading == isLoading &&
        other.error == error;
  }

  @override
  int get hashCode => sections.hashCode ^ isLoading.hashCode ^ error.hashCode;

  @override
  String toString() =>
      'DashboardBuilderState(sections: $sections, isLoading: $isLoading, error: $error)';
}
