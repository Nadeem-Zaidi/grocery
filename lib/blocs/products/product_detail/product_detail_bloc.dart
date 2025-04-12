import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../models/product/product.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc() : super(ProductDetailState.initial()) {
    on<ProductDetailEvent>((event, emit) {
      switch (event) {
        case FetchDetails():
          // TODO: Handle this case.
          throw UnimplementedError();
      }
    });
  }

  Future<void> _fetchProductDetas() async {}
}
