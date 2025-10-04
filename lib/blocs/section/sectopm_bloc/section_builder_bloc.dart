import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fpdart/fpdart.dart';
import 'package:grocery_app/database_service.dart/dashboard/section.dart';
import 'package:grocery_app/models/custom_cards/customcard.dart';
import 'package:grocery_app/widgets/cards/promo_cards.dart';
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
    on<RemoveContent<PlainCard>>(_removeContent<PlainCard>);
    on<RemoveContent<cat.Category>>(_removeContent<cat.Category>);
    on<MultiSelectContent<cat.Category>>(_multiSelectContent<cat.Category>);
    on<MultiSelectContent<PlainCard>>(_multiSelectContent<PlainCard>);
    on<Save>(_save);
    on<SaveVisible>(_saveVisible);
    on<SetSection>(_setSection);
    on<AddImageToContent<PlainCard>>(_addImageToContent<PlainCard>);
    on<UpdateContent<PlainCard>>(_updateContent<PlainCard>);
  }

  Future<void> _updateContent<T>(
      UpdateContent event, Emitter<SectionBuilderState> emit) async {
    try {
      int index = event.index;
      var content = event.content;
      if (state.section != null) {
        var section = state.section as Section<T>;
        var updatedContent = List.from(section!.content)..removeAt(index);
        state.copyWith(
            section: section?.copyWith(content: [...updatedContent, content]));
      }
    } catch (error) {
      print(
          "Cannot add image to to the content in _updatedContent in Sectionbuilderbloc .Error==>${error.toString()}");
    }
  }

  Future<void> _addImageToContent<T extends CustomCard>(
      AddImageToContent event, Emitter<SectionBuilderState> emit) async {
    try {
      int index = event.index;
      String imageUrl = event.imageUrl;
      if (state.section != null && state.section!.content.isNotEmpty) {
        var section = state.section as Section<PlainCard>;
        var content = (section.content[index]).copyWith(imageUrl: imageUrl);
        var updatedContent = List.from(state.section!.content)..removeAt(index);
        emit(state.copyWith(
            section: section!.copyWith(content: [...updatedContent, content])));

        print(state.section?.toMap());
      }
    } catch (error) {
      print("Cannot add image to to the content .Error==>${error.toString()}");
      emit(state.copyWith(error: error.toString()));
    }
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

  void _multiSelectContent<T>(
      MultiSelectContent event, Emitter<SectionBuilderState> emit) {
    try {
      final section = state.section as Section<T>?;
      if (section == null) {
        throw Exception("Section is null");
      }
      emit(state.copyWith(
          section: section
              .copyWith(content: [...section.content, ...event.content])));
    } catch (error) {
      print("Error in _multiSelectContent ==>${error.toString()}");
      emit(state.copyWith(error: "Cannot add content to the section"));
    }
  }

  void _removeContent<T>(
      RemoveContent event, Emitter<SectionBuilderState> emit) {
    try {
      final section = state.section as Section<T>;
      print(event.index);
      if (section != null) {
        if (event.index < 0 && event.index > state.section!.content.length) {
          throw Exception("Index out of bound");
        }
        final updatedContent = List.of(section.content)..removeAt(event.index);
        emit(state.copyWith(
            section: state.section!.copyWith(content: updatedContent)));
      }
    } catch (error) {
      print("Error in _removeContent: ${error.toString()}");
      emit(state.copyWith(error: error.toString()));
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
