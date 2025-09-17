part of 'section_builder_bloc.dart';

@immutable
class SectionBuilderState extends Equatable {
  final Map<String, String> field;
  final List<XFile> images;
  final Section? section;
  final bool loading;
  final String? error;
  final bool saveVisible;
  final String? type;
  const SectionBuilderState({
    this.field = const {},
    this.images = const [],
    required this.section,
    this.loading = false,
    this.error,
    this.saveVisible = false,
    required this.type,
  });

  factory SectionBuilderState.initial() {
    return SectionBuilderState(
        field: const {},
        images: const [],
        section: null,
        loading: false,
        error: null,
        saveVisible: false,
        type: null);
  }

  SectionBuilderState copyWith(
      {Map<String, String>? field,
      List<XFile>? images,
      Section? section,
      bool? loading,
      String? error,
      bool? saveVisible,
      String? type}) {
    return SectionBuilderState(
        field: field ?? this.field,
        images: images ?? this.images,
        section: section ?? this.section,
        loading: loading ?? this.loading,
        error: error ?? this.error,
        saveVisible: saveVisible ?? this.saveVisible,
        type: type ?? this.type);
  }

  @override
  List<Object?> get props =>
      [field, images, section, loading, error, saveVisible, type];
}
