part of 'customcard_bloc.dart';

class CustomCardState extends Equatable {
  final bool loading;
  final CustomCard? customCard;
  final String? error;
  final XFile? imageFile;

  const CustomCardState(
      {this.loading = false, this.customCard, this.error, this.imageFile});

  CustomCardState copyWith(
      {bool? loading,
      CustomCard? customCard,
      String? error,
      XFile? imageFile}) {
    return CustomCardState(
        loading: loading ?? this.loading,
        customCard: customCard ?? this.customCard,
        error: error ?? this.error,
        imageFile: imageFile ?? this.imageFile);
  }

  factory CustomCardState.initial() {
    return CustomCardState(
        loading: false, customCard: null, error: null, imageFile: null);
  }

  @override
  List<Object?> get props => [loading, customCard, error, imageFile];
}
