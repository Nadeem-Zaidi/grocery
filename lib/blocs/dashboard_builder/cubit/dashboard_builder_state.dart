part of 'dashboard_builder_cubit.dart';

@immutable
class DashboardBuilderState {
  final List<Map<String, dynamic>> sections;
  final bool isLoading;
  final String? error;

  const DashboardBuilderState({
    required this.sections,
    required this.isLoading,
    this.error,
  });

  factory DashboardBuilderState.initial() {
    return const DashboardBuilderState(
      sections: [],
      isLoading: false,
    );
  }

  DashboardBuilderState copyWith({
    List<Map<String, dynamic>>? sections,
    bool? isLoading,
    String? error,
  }) {
    return DashboardBuilderState(
      sections: sections ?? this.sections,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
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
