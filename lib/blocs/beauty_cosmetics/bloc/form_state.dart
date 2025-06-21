part of 'form_bloc.dart';

class FormState extends Equatable {
  final bool isLoading;
  final List<FormConfig> formConfig;
  final Map<String, FormConfig> formConfigMap;
  final Map<String, dynamic> errors;
  final String? error;
  final bool isValid;
  final DocumentSnapshot? lastDocument;
  final bool hasReachedMax;
  final List<XFile> productImages;
  final Category? category;
  const FormState({
    required this.formConfigMap,
    required this.errors,
    this.isValid = true,
    this.formConfig = const [],
    this.error,
    this.isLoading = false,
    this.hasReachedMax = false,
    this.lastDocument,
    this.productImages = const [],
    this.category,
  });

  factory FormState.initial() {
    return FormState(
      formConfigMap: {},
      errors: {},
    );
  }

  FormState copyWith({
    List<FormConfig>? formConfig,
    Map<String, FormConfig>? formConfigMap,
    Map<String, dynamic>? errors,
    String? error,
    bool? isValid,
    bool? isLoading,
    bool? hasReachedMax,
    DocumentSnapshot? lastDocument,
    List<XFile>? productImages,
    Category? category,
  }) {
    return FormState(
      formConfig: formConfig ?? this.formConfig,
      formConfigMap: formConfigMap ?? this.formConfigMap,
      errors: errors ?? this.errors,
      error: error ?? this.error,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      lastDocument: lastDocument ?? this.lastDocument,
      productImages: productImages ?? this.productImages,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [
        formConfigMap,
        errors,
        error,
        isValid,
        formConfig,
        isLoading,
        lastDocument,
        hasReachedMax,
        productImages,
        category,
      ];
}
