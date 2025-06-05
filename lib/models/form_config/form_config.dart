import 'package:equatable/equatable.dart';

abstract class VisibilityRule extends Equatable {
  const VisibilityRule();
}

class UserRoleRule extends VisibilityRule {
  final List<dynamic> roles;
  const UserRoleRule({required this.roles});
  factory UserRoleRule.fromMap(Map<String, dynamic> map) {
    return UserRoleRule(roles: map["roles"]);
  }
  @override
  List<Object?> get props => [roles];
}

class FieldDependencyRule extends VisibilityRule {
  final String fieldToWatch;
  final String operator;
  final dynamic value;
  const FieldDependencyRule(
      {required this.fieldToWatch,
      required this.operator,
      required this.value});

  factory FieldDependencyRule.fromMap(Map<String, dynamic> map) {
    return FieldDependencyRule(
        fieldToWatch: map["fieldToWatch"],
        operator: map["operator"],
        value: map["value"]);
  }
  @override
  List<Object?> get props => [fieldToWatch, operator, value];
}

class FormConfig extends Equatable {
  final String? fieldname;
  final String? label;
  final String? datatype;
  final bool required;
  final String? display;
  bool hidden;
  final List<VisibilityRule>? visibilityRules;
  String? defaultValue;

  FormConfig({
    this.fieldname,
    this.label,
    this.datatype,
    this.required = false,
    this.display,
    this.hidden = false,
    this.visibilityRules,
    this.defaultValue,
  });

  bool containsField(String fieldName) {
    if (fieldName == fieldname) {
      return true;
    } else {
      return false;
    }
  }

  bool containsValue(String value) {
    if (value == defaultValue) {
      return true;
    } else {
      return false;
    }
  }

  dynamic getAttribute(String name) {}

  FormConfig copyWith(
      {String? fieldname,
      String? label,
      String? datatype,
      bool? required,
      String? display,
      List<VisibilityRule>? visibilityRules,
      bool? hidden,
      String? defaultValue}) {
    return FormConfig(
        fieldname: fieldname ?? this.fieldname,
        label: label ?? this.label,
        datatype: datatype ?? this.datatype,
        required: required ?? this.required,
        hidden: hidden ?? this.hidden,
        display: display ?? this.display,
        visibilityRules: visibilityRules ?? visibilityRules,
        defaultValue: defaultValue ?? this.defaultValue);
  }

  factory FormConfig.fromMap(Map<String, dynamic> data) {
    List<VisibilityRule>? rules;
    if (data['visibilityRules'] != null && data['visibilityRules'] is List) {
      rules = (data['visibilityRules'] as List<dynamic>)
          .map((ruleMap) {
            final type = ruleMap['type'];
            if (type == 'userRole') {
              return UserRoleRule.fromMap(ruleMap);
            } else if (type == 'fieldDependency') {
              return FieldDependencyRule.fromMap(ruleMap);
            }
            return null;
          })
          .whereType<VisibilityRule>()
          .toList();
    }

    return FormConfig(
        fieldname: data["fieldname"] ?? "",
        label: data["label"] ?? "",
        datatype: data["datatype"] ?? "",
        required: data["required"] is bool
            ? data["required"]
            : (data['required'] == 'true' || data['required'] == true),
        display: data["display"] ?? "text",
        hidden: data["hidden"] is bool
            ? data['hidden']
            : (data['hidden'] == 'true' || data['hidden'] == true),
        visibilityRules: rules,
        defaultValue: data["defaultvalue"] ?? "");
  }

  @override
  List<Object?> get props => [
        fieldname,
        required,
        label,
        datatype,
        hidden,
        visibilityRules,
        display,
        defaultValue
      ];
}
