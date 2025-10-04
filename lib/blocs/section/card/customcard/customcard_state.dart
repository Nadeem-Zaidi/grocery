part of 'customcard_bloc.dart';

class CustomCardState extends Equatable {
  final bool loading;
  final CustomCard? customCard;
  final String? error;
  final XFile? imageFile;
  final String? imageUrl;

  const CustomCardState({
    this.loading = false,
    this.customCard,
    this.error,
    this.imageFile,
    this.imageUrl,
  });

  CustomCardState copyWith(
      {bool? loading,
      CustomCard? customCard,
      String? error,
      XFile? imageFile,
      String? imageUrl}) {
    return CustomCardState(
        loading: loading ?? this.loading,
        customCard: customCard ?? this.customCard,
        error: error ?? this.error,
        imageFile: imageFile,
        imageUrl: imageUrl);
  }

  factory CustomCardState.initial() {
    return CustomCardState(
        loading: false,
        customCard: null,
        error: null,
        imageFile: null,
        imageUrl: null);
  }

  @override
  List<Object?> get props => [loading, customCard, error, imageFile, imageUrl];
}
