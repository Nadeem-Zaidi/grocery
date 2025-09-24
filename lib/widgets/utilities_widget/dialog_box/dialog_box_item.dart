import 'package:image_picker/image_picker.dart';

sealed class DialoBoxItem {
  final String name;
  DialoBoxItem({required this.name});
}

class ItemWithGoto extends DialoBoxItem {
  Function goTo;
  ItemWithGoto({required super.name, required this.goTo});
}

class SelectImageWithBlocEvent extends DialoBoxItem {
  Function addEvent;
  SelectImageWithBlocEvent({required this.addEvent, required super.name});
}
