import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_app/database_service.dart/idatabase_service.dart';
import 'package:meta/meta.dart';

import '../../../models/product/product.dart';

part 'fetch_product_event.dart';
part 'fetch_product_state.dart';

class FetchProductBloc extends Bloc<FetchProductEvent, FetchProductState> {
  IdatabaseService productDb;
  FetchProductBloc(this.productDb) : super(FetchProductState.initial()) {
    on<FetchProductEvent>((event, emit) async {
      switch (event) {
        case FetchProducts(categoryString: String category):
          await _fetchProducts(emit, category);
      }
    });
  }

  // Future<void> _fetchProduct(
  //     Emitter<FetchProductState> emit, String categoryString) async {
  //   int pageSize = 10;
  //   String? startAfterName;
  //   try {
  //     final HttpsCallable callable =
  //         FirebaseFunctions.instance.httpsCallable('getPaginatedProducts');
  //     final response = await callable.call(<String, dynamic>{
  //       'pageSize': pageSize,
  //       if (startAfterName != null) 'startAfterName': startAfterName,
  //     });

  //     final data = response.data;

  //     List<dynamic> products = data['products'];
  //     print(products);
  //     String? nextPageToken = data['nextPageToken'];
  //     List<Product> productList = products
  //         .map((item) => Product.fromMap(Map<String, dynamic>.from(item)))
  //         .toList();

  //     emit(state.copyWith(products: productList, isLoading: false));

  //     if (nextPageToken != null) {
  //       print('Next page token: $nextPageToken');
  //       // Store it to fetch the next page
  //     }
  //   } on FirebaseFunctionsException catch (e) {
  //     print('Functions Exception: ${e.code} - ${e.message}');
  //   } catch (e) {
  //     print('Unknown error: $e');
  //   }
  // }

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
}
