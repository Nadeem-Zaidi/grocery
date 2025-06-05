import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:grocery_app/models/form_config/form_config.dart';

part 'cosmetic_event.dart';
part 'cosmetic_state.dart';

class CosmeticBloc extends Bloc<CosmeticEvent, CosmeticState> {
  final FirebaseFirestore firestore;
  CosmeticBloc({required this.firestore}) : super(CosmeticState.initial()) {
    on<FieldChanged>(_onFieldChanged);
    on<FormInitialized>(_initialize);
    on<ReEvaluateVisibility>(_onReEvaluateVisibility);
  }

  Future<void> _initialize(
      FormInitialized event, Emitter<CosmeticState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      CollectionReference collectionReference = firestore
          .collection("database_configuration")
          .doc("beauty_cosmetic")
          .collection("fields");

      Query query = collectionReference.orderBy("sequence");

      QuerySnapshot querySnapShots = await query.get();
      List<QueryDocumentSnapshot> queryDocumentSnapShot = querySnapShots.docs;

      List<FormConfig> formConfig = queryDocumentSnapShot
          .map((doc) => FormConfig.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      Map<String, FormConfig> forProcessForConfig =
          Map<String, FormConfig>.fromEntries(formConfig
              .map((item) => MapEntry(item.fieldname.toString(), item)));

      emit(state.copyWith(
          formConfigMap: forProcessForConfig,
          formConfig: formConfig,
          isLoading: false));
    } catch (e) {
      print("*****can not load form due to error ==$e");
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _onFieldChanged(FieldChanged event, Emitter<CosmeticState> emit) {
    final fieldName = event.fieldKey;
    final value = event.value;

    // Get the current formConfig map
    final currentMap = state.formConfigMap;

    // Create a shallow copy of the formConfig map
    final updatedMap = Map<String, FormConfig>.from(currentMap);

    // Only update the field that changed
    final updatedField = currentMap[fieldName]?.copyWith(defaultValue: value);
    if (updatedField != null) {
      updatedMap[fieldName] = updatedField;
    }

    // Update the error map for only this field
    final updatedErrors = Map<String, dynamic>.from(state.errors);
    final isRequired = updatedField?.required ?? false;
    if (isRequired && (value == null || value.toString().isEmpty)) {
      updatedErrors[fieldName] = "This field is required";
    } else {
      updatedErrors.remove(fieldName);
    }

    // Emit the new state with only the updated field and errors
    emit(state.copyWith(
      formConfigMap: updatedMap,
      errors: updatedErrors,
    ));
  }

  Map<String, String?> _validateAllFields(
      Map<String, dynamic> values, List<FormConfig> configs) {
    final errors = <String, String?>{};
    for (var config in configs) {
      // Only validate visible fields
      if (!config.hidden) {
        errors[config.fieldname!] =
            _validateField(config, values[config.fieldname!]);
      } else {
        errors[config.fieldname!] = null; // No error for hidden fields
      }
    }
    return errors;
  }

  String? _validateField(FormConfig config, dynamic value) {
    // Pass FormConfig directly
    if (config.hidden) return null; // Don't validate hidden fields

    // Convert value to string for isEmpty check if it's not null, handle various types
    String stringValue;
    if (value is String) {
      stringValue = value;
    } else if (value is List &&
        value.isEmpty &&
        config.datatype == 'array<string>') {
      // For arrays, empty means no elements.
      if (config.required) return "This field is required";
      return null; // Empty array but not required is fine
    } else if (value != null) {
      stringValue = value.toString(); // For int, double, bool
    } else {
      stringValue = ""; // If value is null
    }

    if (config.required && stringValue.isEmpty) {
      if (config.datatype == 'array<string>' &&
          (value == null || (value is List && value.isEmpty))) {
        return "This field is required";
      } else if (config.datatype != 'array<string>' && stringValue.isEmpty) {
        return "This field is required";
      }
    }

    // Add more specific validations based on config.datatype
    if (config.datatype == 'int') {
      if (value != null &&
          value.toString().isNotEmpty &&
          int.tryParse(value.toString()) == null) {
        return "Must be a valid integer";
      }
    } else if (config.datatype == 'double') {
      if (value != null &&
          value.toString().isNotEmpty &&
          double.tryParse(value.toString()) == null) {
        return "Must be a valid number";
      }
    }
    // ... other validations

    return null;
  }

  dynamic _getDefaultValueForType(String? datatype) {
    switch (datatype) {
      case 'string':
      case 'text': // Assuming 'text' display means string data
      case 'textarea':
        return "";
      case 'int':
        return 0;
      case 'double':
        return 0.0;
      case 'bool':
        return false;
      case 'array<string>':
        return <String>[];
      // Add other types as needed
      default:
        return ""; // Default fallback
    }
  }

  void _onReEvaluateVisibility(
      ReEvaluateVisibility event, Emitter<CosmeticState> emit) {
    // List<FormConfig> updatedFormConfig = List.from(state.formConfig);
    // for (int i = 0; i < updatedFormConfig.length; i++) {
    //   var config = updatedFormConfig[i];
    //   bool newHiddenStatus = _evaluateVisibility(config, state.values, "admin");
    //   updatedFormConfig[i] = config.copyWith(hidden: newHiddenStatus);
    // }
    // final newErrors = _validateAllFields(state.values, updatedFormConfig);
    // final isValid = newErrors.values.every((error) => error == null);

    // emit(state.copyWith(
    //     formConfig: updatedFormConfig,
    //     errors: newErrors, // Re-validate after visibility changes
    //     isValid: isValid));
  }

  bool _evaluateVisibility(
      FormConfig config, Map<String, dynamic> currentValue, String userRoles) {
    if (config.visibilityRules == null || config.visibilityRules!.isEmpty) {
      return config.hidden;
    }

    for (var rule in config.visibilityRules!) {
      if (rule is UserRoleRule) {
        if (!rule.roles.contains(userRoles)) {
          return true;
        }
      } else if (rule is FieldDependencyRule) {
        final watchedValue = currentValue[rule.fieldToWatch];
        bool conditionsMet = false;
        switch (rule.operator) {
          case "equals":
            conditionsMet = watchedValue == rule.value;
            break;
          case "notEquals":
            conditionsMet = watchedValue != rule.value;
            break;
        }
        if (!conditionsMet) {
          return true;
        }
      }
    }
    return false;
  }

  bool _checkOverallValidity(
      Map<String, dynamic> values, List<FormConfig> configs) {
    final errors = _validateAllFields(values, configs);
    return errors.values.every((error) => error == null);
  }
}
