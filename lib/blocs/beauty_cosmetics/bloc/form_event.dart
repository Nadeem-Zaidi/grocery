part of 'form_bloc.dart'; // Assuming your BLoC file is named cosmetic_bloc.dart

sealed class FormEvent extends Equatable {
  const FormEvent();

  @override
  List<Object?> get props => [];
}

@immutable
class SetFormCategory extends FormEvent {
  final Category category;
  const SetFormCategory({required this.category});
}

@immutable
class FormInitialized extends FormEvent {
  const FormInitialized();
}

class FieldChanged extends FormEvent {
  final String fieldKey;
  final dynamic value;
  final String datatype;

  const FieldChanged(
      {required this.fieldKey, required this.value, required this.datatype});

  @override
  List<Object?> get props => [fieldKey, value];
}

class FormSave extends FormEvent {
  FormSave();
}

class FormPickImages extends FormEvent {}

class FormOnFieldSwitchChange extends FormEvent {
  String value;
  FormOnFieldSwitchChange({required this.value});
}

@immutable
class FormRemovePickedImages extends FormEvent {
  final int index;
  const FormRemovePickedImages({required this.index});
}

class ReEvaluateVisibility extends FormEvent {
  const ReEvaluateVisibility();
}

@immutable
class ItemCreated<T> extends FormEvent {
  final T item;
  const ItemCreated({required this.item});
}
