abstract class IEntity<T> {
  Map<String, dynamic> toMap();
  T copyWith();
}
