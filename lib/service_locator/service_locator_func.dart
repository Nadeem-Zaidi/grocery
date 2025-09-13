import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/database_service.dart/db_service.dart';
import 'package:grocery_app/models/form_config/form_config.dart';
import 'package:grocery_app/service_locator/service_locator.dart';
import '../database_service.dart/ientity.dart';
import '../models/category.dart' as cat;
import '../models/product/productt.dart';

// Create a typedef for a generic DBService factory
typedef DBServiceFactory<T> = DBService<IEntity> Function(
    String collectionPath);

void registerServices() {
  var serviceLocator = ServiceLocator();

  // Register FirebaseFirestore as a singleton
  serviceLocator
      .registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  // Register factory for DBServiceFactory<Category>
  serviceLocator.registerFactory<DBService<cat.Category>>(() {
    return DBService<cat.Category>(
      fireStore: serviceLocator.get<FirebaseFirestore>(),
      collectionPath: "categories",
    );
  });

  serviceLocator.registerFactory<DBService<Productt>>(() {
    return DBService<Productt>(
        fireStore: serviceLocator.get<FirebaseFirestore>(),
        collectionPath: 'products');
  });

  serviceLocator
      .registerParamFactory<DBService<FormConfig>, String>((collectionPath) {
    return DBService<FormConfig>(
        fireStore: serviceLocator.get<FirebaseFirestore>(),
        collectionPath: collectionPath);
  });

  serviceLocator
      .registerParamFactory<DBService<Productt>, String>((collectionPath) {
    return DBService<Productt>(
        fireStore: serviceLocator.get<FirebaseFirestore>(),
        collectionPath: collectionPath);
  });

  // Register factory for DBServiceFactory<FormConfig>
}
