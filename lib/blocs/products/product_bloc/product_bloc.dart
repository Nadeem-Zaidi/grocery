import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/database_service.dart/product/firestore_product_service.dart';
import 'package:meta/meta.dart';

import '../../../models/product/product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  FirestoreProductService fireStore;
  ProductBloc(this.fireStore) : super(ProductState.initial()) {
    on<ProductEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  Future<void> createProduct(
      Emitter<ProductState> emit, Product product) async {
    try {
      emit(state.copyWith(isLoading: true));

      String id = await fireStore.create(product);
      Product? newProduct = await fireStore.getById(id);

      if (newProduct == null) {
        throw Exception("Product cannot be created");
      }

      emit(state.copyWith(
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }
}
