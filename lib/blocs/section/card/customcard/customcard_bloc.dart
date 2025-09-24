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
      final customCard = switch (state.customCard) {
        // TODO: Handle this case.
        null => throw UnimplementedError(),
        // TODO: Handle this case.
        PlainCard s => s.copyWith(title: event.title),
        // TODO: Handle this case.
        DiscountCard() => throw UnimplementedError(),
        // TODO: Handle this case.
        FeaturedCard() => throw UnimplementedError(),
      };

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
