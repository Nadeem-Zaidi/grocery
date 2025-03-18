part of 'category_update_bloc.dart';

@immutable
sealed class CategoryUpdateEvent {}

class InitializeExisting extends CategoryUpdateEvent {
  final String id;
  final String name;
  final String path;
  final String parent;
  final String url;
  InitializeExisting({
    required this.id,
    required this.name,
    required this.path,
    required this.parent,
    required this.url,
  });
}
