import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/database_service.dart/IDBService.dart';

import '../../../models/product/productt.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  IDBService<Productt> dbService;
  ProductDetailBloc({required this.dbService})
      : super(ProductDetailState.initial()) {
    on<ProductDetailEvent>((event, emit) async {
      switch (event) {
        case FetchDetails(productId: String id):
          await _fetchProductDetails(emit, id);
        case ShowProductDetails():
          _showProductDetails(emit);
        case ShowProductHighlights():
          _showProductHighlights(emit);
        case ShowProductInfo():
          _showProductInfo(emit);
      }
    });
  }

  Future<void> _fetchProductDetails(
      Emitter<ProductDetailState> emit, String id) async {
    try {
      emit(state.copyWith(isLoading: true));
      Productt? product = await dbService.getById(id);
      if (product == null) {
        emit(state.copyWith(error: "Something went wrong in fetching product"));
      }
      emit(state.copyWith(product: product, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, error: "Something went wrong in fetching product"));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _showProductDetails(Emitter<ProductDetailState> emit) async {
    try {
      if (state.viewProductDetails == false &&
          (state.showHighlights == true || state.showInfo == true)) {
        emit(state.copyWith(showHighlights: false, showInfo: false));
      }
      emit(state.copyWith(viewProductDetails: !state.viewProductDetails));
    } catch (e) {
      emit(state.copyWith(
          error: "Something went wrong in expanding 'view product details'"));
    }
  }

  void _showProductHighlights(Emitter<ProductDetailState> emit) {
    try {
      emit(state.copyWith(showHighlights: !state.showHighlights));
    } catch (e) {
      emit(state.copyWith(
          error: "something went wropng in expanding 'Highlights section'"));
    }
  }

  void _showProductInfo(Emitter<ProductDetailState> emit) {
    try {
      emit(state.copyWith(showInfo: !state.showInfo));
    } catch (e) {
      emit(state.copyWith(
          error: "Something went wrong in expanding 'Info section'"));
    }
  }
}
