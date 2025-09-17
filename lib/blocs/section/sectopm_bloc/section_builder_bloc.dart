import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fpdart/fpdart.dart';
import 'package:grocery_app/database_service.dart/dashboard/section.dart';
import 'package:grocery_app/widgets/card/custom_card.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/category.dart' as cat;
import '../../../models/product/productt.dart';

part 'section_builder_event.dart';
part 'section_builder_state.dart';

class SectionBuilderBloc
    extends Bloc<SectionBuilderEvent, SectionBuilderState> {
  final ImagePicker _imagePicker = ImagePicker();
  SectionBuilderBloc() : super(SectionBuilderState.initial()) {
    on<FieldChange>((event, emit) {
      _fieldChange(emit, event.field, event.value);
    });

    on<PickImages>(_pickImages);
    on<RemoveImages>(_removePickedImages);
    on<AddContent>(_addContent);
    on<RemoveContent>(_removeContent);
    on<MultiSelectContent>(_multiSelectContent);
    on<Save>(_save);
    on<SaveVisible>(_saveVisible);
    on<SetSection>(_setSection);
  }

  void _setSection(SetSection event, Emitter<SectionBuilderState> emit) {
    emit(state.copyWith(section: event.section));
  }

  void _fieldChange(
      Emitter<SectionBuilderState> emit, String field, String value) {
    if (state.section == null) {
      throw Exception("Section is null");
    }
    Map<String, String> updated = Map<String, String>.from(state.field);
    updated[field] = value;
    emit(
        state.copyWith(section: state.section!.copyWith(name: updated[field])));
  }

  void _addContent(AddContent event, Emitter<SectionBuilderState> emit) {
    try {
      if (state.section == null) {
        throw Exception("Section is null");
      }
    } catch (e) {
      print("error in _addContent function==>${e.toString()}");
      emit(state.copyWith(error: "Cannot add content to this section"));
    }
  }

  void _multiSelectContent(
      MultiSelectContent event, Emitter<SectionBuilderState> emit) {
    print(event.content);
    print(state.section!.content);
    try {
      if (state.section == null) {
        throw Exception("Section is null");
      }
      final section = switch (state.section) {
        CategorySection s => s.copyWith(
            content: <cat.Category>[
              ...state.section!.content,
              ...event.content
            ],
          ),
        ProductSpotlightSection s => s.copyWith(
            content: [...s.content, ...event.content] as List<Productt>,
          ),
        PromotionSection s => s.copyWith(
            content: <PromoCard>[...state.section!.content, ...event.content]),
        // TODO: Handle this case.
        null => throw UnimplementedError(),
      };

      emit(state.copyWith(section: section as Section));
    } catch (error) {
      print("Error in _multiSelectContent ==>${error.toString()}");
    }
  }

  void _removeContent(RemoveContent event, Emitter<SectionBuilderState> emit) {
    try {
      if (state.section != null) {
        if (event.index < 0 && event.index > state.section!.content.length) {
          throw Exception("Index out of bound");
        }
        final updatedContent = List.of(state.section!.content)
          ..removeAt(event.index);

        final newSection = switch (state.section) {
          CategorySection s => s.copyWith(
              content:
                  updatedContent.cast<cat.Category>() as List<cat.Category>?),
          ProductSpotlightSection s =>
            s.copyWith(content: updatedContent.cast<Productt>()),
          // TODO: Handle this case.
          PromotionSection() => throw UnimplementedError(),
          // TODO: Handle this case.
          null => throw UnimplementedError(),
        };

        emit(state.copyWith(section: newSection as Section));
      }
    } catch (e) {
      print("Error in _removeContent: $e");
    }
  }

  Future<void> _pickImages(
      PickImages event, Emitter<SectionBuilderState> emit) async {
    try {
      emit(state.copyWith(loading: true));
      final List<XFile> pickImages = await _imagePicker.pickMultiImage();
      if (pickImages.length <= 5) {
        emit(state.copyWith(
            images: [...state.images, ...pickImages], loading: false));
      } else {
        emit(state.copyWith(
            loading: false, error: "Cannot select more than 5 images"));
      }
    } catch (e) {
      print("error in section builder bloc image picker==>${e.toString()}");
      emit(state.copyWith(loading: false, error: "Error in selecting images"));
    }
  }

  Future<void> _removePickedImages(
      RemoveImages event, Emitter<SectionBuilderState> emit) async {
    int index = event.index;
    try {
      if (index < 0 && index >= state.images.length) {
        throw RangeError("Index is out of bound");
      }
      final updatedList = List<XFile>.from(state.images)..removeAt(index);
      emit(state.copyWith(images: updatedList));
    } catch (e) {
      print("Error in section builder _removePickedImage ==>${e.toString()}");
      emit(state.copyWith(loading: false, error: "Cannot remove the images"));
    }
  }

  void _saveVisible(SaveVisible event, Emitter<SectionBuilderState> emit) {
    bool saveVisible = false;
    Map<String, String> fields = Map<String, String>.from(state.field);
    Map<String, String>.fromEntries(
      state.field.entries
          .where((entry) => (entry.key == 'name') && entry.value.isNotEmpty),
    );
  }

  void _save(Save event, Emitter<SectionBuilderState> emit) {
    try {
      print(state);
    } catch (e) {}
  }
}
