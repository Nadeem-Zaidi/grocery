part of 'cosmetic_bloc.dart'; // Assuming your BLoC file is named cosmetic_bloc.dart

sealed class CosmeticEvent extends Equatable {
  const CosmeticEvent();

  @override
  List<Object?> get props =>
      []; // It's good practice to use List<Object?> for props
}

class FormInitialized extends CosmeticEvent {
  // If you need to pass user context (like role) during initialization,
  // you can add it here. For example:
  // final String userRole;
  // const FormInitialized({required this.userRole});
  // @override
  // List<Object?> get props => [userRole];

  // If no parameters are needed for initialization for now:
  const FormInitialized();
}

class FieldChanged extends CosmeticEvent {
  final String fieldKey;
  final dynamic value; // Changed to dynamic to support various data types

  const FieldChanged({required this.fieldKey, required this.value});

  @override
  List<Object?> get props => [fieldKey, value];
}

// New event for explicitly re-evaluating field visibility
class ReEvaluateVisibility extends CosmeticEvent {
  const ReEvaluateVisibility();
  // No specific props needed for this event, so the base class props are sufficient.
}

// If you plan to add a form submission event:
/*
class FormSubmitted extends CosmeticEvent {
  const FormSubmitted();
}
*/
