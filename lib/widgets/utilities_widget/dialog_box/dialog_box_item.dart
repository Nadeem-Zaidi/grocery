sealed class DialoBoxItem {
  final String name;
  DialoBoxItem({required this.name});
}

class ItemWithGoto extends DialoBoxItem {
  Function goTo;
  ItemWithGoto({required super.name, required this.goTo});
}
