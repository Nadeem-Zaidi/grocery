import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/database_service.dart/product/firestore_product_service.dart';
import 'package:meta/meta.dart';

import '../../../models/product/product.dart';

part 'fetch_product_event.dart';
part 'fetch_product_state.dart';

class FetchProductBloc extends Bloc<FetchProductEvent, FetchProductState> {
  FirestoreProductService productDb;
  FirebaseFirestore firestore;
  FetchProductBloc(this.productDb, this.firestore)
      : super(FetchProductState.initial()) {
    on<FetchProductEvent>((event, emit) async {
      switch (event) {
        case FetchProducts(categoryString: String category):
          await _fetchProducts(emit, category);
        case FetchProductWhere(categoryString: String cs):
          await _productWhere(emit, cs);
        // case ProductStream(products: List<Product> products):
        //   await _getProduct(emit, products);
        // case ProductsUpdated(
        //     products: List<Product> p,
        //     lastDocument: DocumentSnapshot? ld
        //   ):
        //   await _productsUpdated(emit, p, ld);
        // case LoadProducts():
        //   await _loadProducts();
        // case LoadMore():
        //   await _loadMore();
        // case ProductNext(
        //     products: List<Product> p,
        //     lastDocument: DocumentSnapshot? ld
        //   ):
        //   _productNext(emit, p, ld);
      }
    });
  }

  Future<void> _fetchProducts(
      Emitter<FetchProductState> emit, String category) async {
    try {
      emit(state.copyWith(isLoading: true));
      final (newProducts, newLastDocument) =
          await productDb.getAll(10, state.lastDocument);

      if (newProducts.isEmpty) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        emit(state.copyWith(
            products: [...state.products, ...newProducts],
            lastDocument: newLastDocument,
            isLoading: false));
      }
    } catch (e) {
      print("error occured while fetching products duie to ==$e");
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _productWhere(
      Emitter<FetchProductState> emit, String categoryString) async {
    try {
      var (products, lastDoc, hasReachedmax) = await productDb.whereClause(
          (collection) => collection
              .where("categorypath", isEqualTo: categoryString)
              .orderBy("name")
              .limit(15),
          state.lastDocument);

      if (products.isEmpty) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        emit(state.copyWith(
            products: [...state.products, ...products],
            lastDocument: lastDoc,
            isLoading: false));
      }
    } catch (e) {
      print("error occured while fetching products duie to ==$e");
      emit(state.copyWith(error: e.toString(), isLoading: false));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  // Future<void> _getProduct(
  //     Emitter<FetchProductState> emit, List<Product> products) async {
  //   try {
  //     state.copyWith(isLoading: true);
  //     emit(state.copyWith(products: [...products]));
  //   } catch (e) {
  //     print(e);
  //     emit(state.copyWith(error: e.toString(), isLoading: false));
  //   } finally {
  //     emit(state.copyWith(isLoading: false));
  //   }
  // }

  // Future<void> _loadProducts() async {
  //   productDb.startStream();
  //   _productsSubscription = productDb.productsStream.listen((tuple) {
  //     var (products, lastDocument) = tuple;
  //     add(ProductsUpdated(products: products, lastDocument: lastDocument));
  //   }, onError: (error) {});
  // }

  // Future<void> _productsUpdated(Emitter<FetchProductState> emit,
  //     List<Product> products, DocumentSnapshot? ld) async {
  //   try {
  //     emit(state.copyWith(isLoading: true));
  //     emit(state.copyWith(products: [...products], lastDocument: ld));

  //     emit(state.copyWith(isLoading: false));
  //   } catch (error) {
  //     state.copyWith(error: error.toString(), isLoading: false);
  //   } finally {
  //     state.copyWith(isLoading: false);
  //   }
  // }

  // Future<void> _loadMore() async {
  //   state.copyWith(isLoading: true);
  //   productDb.startStream(lastDocument: state.lastDocument);
  //   _productsSubscription = productDb.productsStream.listen((tuple) {
  //     var (products, lastDocument) = tuple;
  //     add(ProductNext(products: products, lastDocument: lastDocument));
  //   }, onError: (error) {});
  // }

  // Future<void> _productNext(
  //     emit, List<Product> products, DocumentSnapshot? ld) async {
  //   try {
  //     emit(state.copyWith(isLoading: true));
  //     if (products.isEmpty) {
  //       emit(state.copyWith(hasReachedMax: true));
  //     } else {
  //       emit(state.copyWith(products: [...products], lastDocument: ld));
  //     }

  //     emit(state.copyWith(isLoading: false));
  //   } catch (error) {
  //     state.copyWith(error: error.toString(), isLoading: false);
  //   } finally {
  //     state.copyWith(isLoading: false);
  //   }
  // }

  // @override
  // Future<void> close() {
  //   _productsSubscription?.cancel();
  //   productDb.dispose();
  //   return super.close();
  // }
}
