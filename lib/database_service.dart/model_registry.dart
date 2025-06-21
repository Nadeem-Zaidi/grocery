class ModelRegistry {
  static final Map<Type, dynamic Function(Map<String, dynamic>)> _registry = {};

  static void register<T>(T Function(Map<String, dynamic>) factory) {
    _registry[T] = factory;
  }

  static T fromMap<T>(Map<String, dynamic> map) {
    final creator = _registry[T];
    if (creator == null) {
      throw Exception('No factory registered for type $T');
    }
    return creator(map) as T;
  }
}
