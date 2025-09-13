part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

@immutable
class AddSection extends DashboardEvent {
  final Section section;
  const AddSection({required this.section});
}

@immutable
class RemoveSection extends DashboardEvent {
  final int index;
  final String? id;
  const RemoveSection({required this.index, required this.id});
}

@immutable
class SavePage extends DashboardEvent {}

class AddSectionToSave extends DashboardEvent {
  final Section section;
  AddSectionToSave({required this.section});
}
