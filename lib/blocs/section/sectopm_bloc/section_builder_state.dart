part of 'section_builder_bloc.dart';

@immutable
class SectionBuilderState<T> extends Equatable {
  final Map<String, String> field;
  final List<XFile> images;
  final Section section;
  final bool loading;
  final String? error;
  final bool saveVisible;
  final String type;
  const SectionBuilderState({
    this.field = const {},
    this.images = const [],
    required this.section,
    this.loading = false,
    this.error,
    this.saveVisible = false,
    this.type = 'category',
  });

  factory SectionBuilderState.initial() {
    late final Section section;
    String type = 'category';
    if (T == CategorySection) {
      section = CategorySection(
        id: null,
        name: '',
        type: 'category',
        sequence: 0,
      );
      type = 'category';
    } else if (T == ProductSpotlightSection) {
      section = ProductSpotlightSection(
        id: null,
        name: '',
        type: 'product',
        sequence: 0,
      );
      type = 'product';
    } else {
      throw UnimplementedError('Unknown section type: $T');
    }
    return SectionBuilderState<T>(
      section: section,
      type: type,
    );
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
