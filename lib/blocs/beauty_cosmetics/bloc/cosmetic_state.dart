part of 'cosmetic_bloc.dart';

class CosmeticState extends Equatable {
  final bool isLoading;
  final List<FormConfig> formConfig;
  final Map<String, FormConfig> formConfigMap;
  final Map<String, dynamic> errors;
  final String? error;
  final bool isValid;
  const CosmeticState(
      {required this.formConfigMap,
      required this.errors,
      this.isValid = true,
      this.formConfig = const [],
      this.error,
      this.isLoading = false});

  factory CosmeticState.initial() {
    return CosmeticState(
      formConfigMap: {},
      errors: {},
    );
  }

  CosmeticState copyWith({
    List<FormConfig>? formConfig,
    Map<String, FormConfig>? formConfigMap,
    Map<String, dynamic>? errors,
    String? error,
    bool? isValid,
    bool? isLoading,
  }) {
    return CosmeticState(
        formConfig: formConfig ?? this.formConfig,
        formConfigMap: formConfigMap ?? this.formConfigMap,
        errors: errors ?? this.errors,
        error: error ?? this.error,
        isValid: isValid ?? this.isValid,
        isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object> get props =>
      [formConfigMap, errors, isValid, formConfig, isLoading];
}
