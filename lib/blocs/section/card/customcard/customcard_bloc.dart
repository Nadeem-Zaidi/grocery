import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/blocs/categories/create_category_bloc/category_create_bloc.dart';
import 'package:grocery_app/models/custom_cards/customcard.dart';
import 'package:image_picker/image_picker.dart';

part 'customcard_event.dart';
part 'customcard_state.dart';

class CustomCardBloc extends Bloc<CustomCardEvent, CustomCardState> {
  ImagePicker _imagePicker = ImagePicker();
  CustomCardBloc() : super(CustomCardState.initial()) {
    on<SetTitle>(_setTitle);
    on<SetImage>(_setImage);
    on<SetBackgroundColor>(_setBackgroundColor);
    on<SelectImage>(_pickImage);
    on<SelectImageUrl>(_pickImageUrl);
    on<RemoveImage>(_removeImage);
  }

  void _removeImage(RemoveImage event, Emitter<CustomCardState> emit) {
    try {
      print("running state");
      print(state.imageUrl);
      print(state.imageFile);
      emit(state.copyWith(imageFile: null, imageUrl: null));
    } catch (error) {
      print("Error in removing the image. Error=>${error.toString()}");
      emit(state.copyWith(error: "Cannot remove the image"));
    }
  }

  Future<void> _pickImageUrl(
      SelectImageUrl event, Emitter<CustomCardState> emit) async {
    try {
      print(event.imageUrl);
      print(state.customCard.runtimeType);
      final card = state.customCard;
      emit(state.copyWith(imageUrl: event.imageUrl));

      if (card is PlainCard) {
        print("hurray running here");
        emit(state.copyWith(
            customCard: (state.customCard as PlainCard)
                .copyWith(imageUrl: event.imageUrl)));
      }
    } catch (error) {
      print("Error in selecting an image due to error==>${error.toString()}");
      emit(state.copyWith(error: "cannot select an image"));
    }
  }

  Future<void> _pickImage(
      SelectImage event, Emitter<CustomCardState> emit) async {
    try {
      emit(state.copyWith(loading: true));
      final imageFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        emit(state.copyWith(imageFile: imageFile, loading: false));
      }
    } catch (error) {
      emit(state.copyWith(
          error: "Something went wrong in loading an image", loading: false));
    }
  }

  void _setTitle(SetTitle event, Emitter<CustomCardState> emit) {
    try {
      final customCard = state.customCard?.copyWith();

      emit(state.copyWith(customCard: customCard));
    } catch (error) {
      print("Error in adding the title==>${error.toString()}");
      emit(state.copyWith(error: "Something went wrong in setting the title"));
    }
  }

  void _setImage(SetImage event, Emitter<CustomCardState> emit) {}

  void _setBackgroundColor(
      SetBackgroundColor event, Emitter<CustomCardState> emit) {}
}
