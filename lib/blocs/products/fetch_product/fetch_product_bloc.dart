import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/database_service.dart/product/firestore_product_service.dart';
import 'package:meta/meta.dart';
import 'package:collection/collection.dart';

import '../../../models/product/product.dart';

part 'fetch_product_event.dart';
part 'fetch_product_state.dart';

class FetchProductBloc extends Bloc<FetchProductEvent, FetchProductState> {
  FirestoreProductService fireStore;

  FetchProductBloc(this.fireStore) : super(FetchProductState.initial()) {
    on<FetchProductEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  Future<void> fetchProduct(Emitter<FetchProductState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      var (products, lastDocument) =
          await fireStore.fetchProducts(10, state.lastDocument);

      if (products.isEmpty) {
        emit(state.copyWith(hasReachedMax: true, isLoading: false));
      } else {
        List<Product> newList = [...state.products, ...products];
        emit(state.copyWith(
            products: newList, isLoading: false, lastDocument: lastDocument));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
