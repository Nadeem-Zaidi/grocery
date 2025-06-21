import 'package:grocery_app/models/category.dart';

import '../models/form_config/form_config.dart';
import 'model_registry.dart';

void registerModels() {
  ModelRegistry.register<FormConfig>((map) => FormConfig.fromMap(map));
  ModelRegistry.register<Category>((map) => Category.fromMap(map));
}
