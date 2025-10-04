part of 'section_builder_bloc.dart';

sealed class SectionBuilderEvent extends Equatable {
  const SectionBuilderEvent();

  @override
  List<Object> get props => [];
}

@immutable
class FieldChange extends SectionBuilderEvent {
  final String field;
  final String value;

  const FieldChange({required this.field, required this.value});
}

@immutable
class AddContent<T> extends SectionBuilderEvent {
  final T content;
  const AddContent({required this.content});
}

@immutable
class MultiSelectContent<T> extends SectionBuilderEvent {
  final List<T> content;
  const MultiSelectContent({this.content = const []});
}

@immutable
class RemoveContent<T> extends SectionBuilderEvent {
  final int index;
  const RemoveContent({required this.index});
}

@immutable
class PickImages extends SectionBuilderEvent {}

@immutable
class RemoveImages extends SectionBuilderEvent {
  final int index;
  const RemoveImages({required this.index});
}

@immutable
class Save<T> extends SectionBuilderEvent {}

@immutable
class SaveVisible extends SectionBuilderEvent {}

@immutable
class SetSection extends SectionBuilderEvent {
  final Section section;
  const SetSection({required this.section});
}

@immutable
class AddImageToContent<T extends CustomCard> extends SectionBuilderEvent {
  final int index;
  final String imageUrl;
  const AddImageToContent({required this.index, required this.imageUrl});
}

@immutable
class UpdateContent<T> extends SectionBuilderEvent {
  final T content;
  final int index;
  UpdateContent({required this.content, required this.index});
}
