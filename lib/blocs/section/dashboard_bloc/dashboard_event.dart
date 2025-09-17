part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

@immutable
class AddColor extends DashboardEvent {
  final String color;
  const AddColor({required this.color});
}

@immutable
class AddSection extends DashboardEvent {
  final Section section;
  const AddSection({required this.section});
}

@immutable
class AddPromoBanner extends DashboardEvent {
  final Section section;
  const AddPromoBanner({required this.section});
}

@immutable
class RemoveSection extends DashboardEvent {
  final int index;
  final String? id;
  const RemoveSection({required this.index, required this.id});
}

@immutable
class SavePage extends DashboardEvent {}

@immutable
class AddSectionToSave extends DashboardEvent {
  final Section section;
  const AddSectionToSave({required this.section});
}

@immutable
class AddPromoToSave extends DashboardEvent {
  final Section section;
  const AddPromoToSave({required this.section});
}
