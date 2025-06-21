import 'package:equatable/equatable.dart';

class FormConfig extends Equatable {
  final String? fieldname;
  final String? label;
  final String? hint;
  final String? datatype;
  final bool required;
  final String? display;
  bool hidden;
  dynamic defaultValue;
  dynamic rules;
  dynamic reevaluate;

  FormConfig({
    this.fieldname,
    this.label,
    this.hint,
    this.datatype,
    this.required = false,
    this.display,
    this.hidden = false,
    this.defaultValue,
    this.rules = const [],
    this.reevaluate = const [],
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

  FormConfig copyWith({
    String? fieldname,
    String? label,
    String? datatype,
    bool? required,
    String? display,
    bool? hidden,
    dynamic defaultValue,
    dynamic rules,
    dynamic reevaluate,
  }) {
    return FormConfig(
        fieldname: fieldname ?? this.fieldname,
        label: label ?? this.label,
        datatype: datatype ?? this.datatype,
        required: required ?? this.required,
        hidden: hidden ?? this.hidden,
        display: display ?? this.display,
        defaultValue: defaultValue ?? this.defaultValue,
        rules: rules ?? this.rules,
        reevaluate: reevaluate ?? this.reevaluate);
  }

  factory FormConfig.fromMap(Map<String, dynamic> data) {
    return FormConfig(
      fieldname: data["fieldname"] ?? "",
      label: data["label"] ?? "",
      hint: data["hint"] ?? "",
      datatype: data["datatype"] ?? "",
      required: data["required"] is bool
          ? data["required"]
          : (data['required'] == 'true' || data['required'] == true),
      display: data["display"] ?? "text",
      hidden: data["hidden"] is bool
          ? data['hidden']
          : (data['hidden'] == 'true' || data['hidden'] == true),
      defaultValue: data["defaultvalue"] ?? "",
      rules: data["rules"],
      reevaluate: data["reevaluate"],
    );
  }

  @override
  List<Object?> get props => [
        fieldname,
        required,
        label,
        hint,
        datatype,
        hidden,
        display,
        defaultValue,
        rules,
        reevaluate
      ];
}
