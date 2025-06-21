class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;

  ServiceLocator._internal();

  final Map<Type, dynamic> _services = {};
  final Map<Type, dynamic> _factoriesWithParams = {};

  void registerSingleton<T>(T instance) {
    _services[T] = instance;
  }

  void registerFactory<T>(T Function() builder) {
    _services[T] = builder;
  }

  void registerParamFactory<T, P>(T Function(P param) builder) {
    _factoriesWithParams[T] = builder;
  }

  T get<T>() {
    final service = _services[T];
    if (service is Function) {
      return service(); // zero-arg factory
    }
    return service as T;
  }

  T getWithParam<T, P>(P param) {
    final factory = _factoriesWithParams[T];
    if (factory == null) {
      throw Exception("Factory with param for type $T not registered");
    }
    return (factory as T Function(P))(param);
  }
}
