part of 'customcard_bloc.dart';

sealed class CustomCardEvent extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
class SetTitle extends CustomCardEvent {
  final String title;
  SetTitle({required this.title});
}

@immutable
class SetImage extends CustomCardEvent {
  final String imageUrl;
  SetImage({required this.imageUrl});
}

@immutable
class SetBackgroundColor extends CustomCardEvent {
  final String colorName;
  SetBackgroundColor({required this.colorName});
}

class SelectImage extends CustomCardEvent {}
