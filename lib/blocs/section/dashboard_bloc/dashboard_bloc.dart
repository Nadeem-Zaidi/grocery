import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/blocs/section/sectopm_bloc/section_builder_bloc.dart';
import 'package:grocery_app/models/page_builder/page_builder.dart';
// import 'package:grocery_app/models/sections/section.dart';
import 'package:grocery_app/database_service.dart/dashboard/section.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ImagePicker _pickImage = ImagePicker();
  DashboardBloc() : super(DashboardState.initial()) {
    on<DashboardEvent>((event, emit) {});
    on<AddSection>(_addSection);
    on<RemoveSection>(_removeSection);
    on<SavePage>(_savePage);
    on<AddSectionToSave>(_addSectionToSave);
    on<AddPromoBanner>(_addPromoBanner);
    on<AddPromoToSave>(_addPromoToSave);
    on<AddColor>(_addColor);
    on<SelectAppBarImge>(_appBarImage);
  }

  Future<void> _appBarImage(
      SelectAppBarImge event, Emitter<DashboardState> emit) async {
    try {
      XFile? pickedImage =
          await _pickImage.pickImage(source: ImageSource.gallery);
      if (pickedImage == null) {
        throw Exception("Cannot select an image");
      }
      final PaletteGenerator generator =
          await PaletteGenerator.fromImageProvider(
        FileImage(
          File(pickedImage.path),
        ),
        size: const Size(200, 100),
      );

      final color = generator.dominantColor?.color ?? Colors.grey;
      String hexColor = '#${color.value.toRadixString(16).padLeft(8, '0')}';

      emit(state.copyWith(
          page: state.page.copyWith(
              appBarImage: pickedImage, dominantColorAppBar: hexColor)));
    } catch (error) {
      print("error in picking image in _appBarImage in DashBoardBloc");
      emit(state.copyWith(error: "Cannot select an image"));
    }
  }

  void _addSectionToSave(AddSectionToSave event, Emitter<DashboardState> emit) {
    state.page.sections[event.section.id.toString()] = event.section;
    emit(state.copyWith(
        page: state.page.copyWith(sections: {...state.page.sections})));
  }

  void _addPromoToSave(AddPromoToSave event, Emitter<DashboardState> emit) {
    try {
      state.page.promoBanner[event.section.id.toString()] = event.section;
      emit(state.copyWith(
          page: state.page.copyWith(promoBanner: state.page.promoBanner)));
    } catch (error) {
      print("error in the _addPromoToSave in DashboardBloc");
      emit(state.copyWith(error: "Something went wrong in adding promo"));
    }
  }

  void _addSection(AddSection event, Emitter<DashboardState> emit) {
    try {
      Map<String, Section> section = {};
      section[event.section.id.toString()] = event.section;
      emit(state.copyWith(
          page: state.page
              .copyWith(sections: {...state.page.sections, ...section})));
    } catch (error) {
      print(
          "Error in adding the section in _addSection due to error==>${error.toString()}");
      emit(state.copyWith(
          error: "Cannot add section.See the logs for more details"));
    }
  }

  void _addPromoBanner(AddPromoBanner event, Emitter<DashboardState> emit) {
    try {
      Map<String, Section> section = {};
      section[event.section.id.toString()] = event.section;
      emit(
          state.copyWith(page: state.page.copyWith(promoBanner: {...section})));
    } catch (error) {}
  }

  void _removeSection(RemoveSection event, Emitter<DashboardState> emit) {
    try {
      // if (event.id != null && event.id.toString().isNotEmpty) {
      //   //remove from the data base and then from the list
      // } else {
      //   List<Section> sections = List<Section>.from(state.sections)
      //     ..removeAt(event.index);
      //   emit(state.copyWith(sections: sections));
      // }
    } catch (error) {
      print(
          "Error in adding the section in _removeSection due to error==>${error.toString()}");
      emit(state.copyWith(
          error: "Cannot remove section.See the logs for more details"));
    }
  }

  void _addColor(AddColor event, Emitter<DashboardState> emit) {
    try {
      emit(state.copyWith(
          page: state.page.copyWith(dominantColorAppBar: event.color)));
    } catch (error) {
      print("Error in _addColor function in Dashboard bloc==>$error");
      emit(state.copyWith(error: "Something went wrong in adding color"));
    }
  }

  Future<void> _savePage(SavePage event, Emitter<DashboardState> emit) async {
    print(state.page.toMap());
  }
}

Future<Color> getDominantColor(File imageFile) async {
  // Load image bytes
  final data = await imageFile.readAsBytes();
  final codec = await ui.instantiateImageCodec(data);
  final frame = await codec.getNextFrame();
  final image = frame.image;

  // Convert to byte data (RGBA)
  final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);

  final pixels = byteData!.buffer.asUint32List();
  final Map<int, int> colorCount = {};

  for (final pixel in pixels) {
    colorCount[pixel] = (colorCount[pixel] ?? 0) + 1;
  }

  // Find most common color
  int dominantColorValue =
      colorCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;

  return Color(dominantColorValue);
}
