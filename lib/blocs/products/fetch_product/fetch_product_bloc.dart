import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_app/database_service.dart/product/firestore_product_service.dart';
import 'package:meta/meta.dart';
import 'package:collection/collection.dart';

import '../../../models/product/product.dart';

part 'fetch_product_event.dart';
part 'fetch_product_state.dart';

class FetchProductBloc extends Bloc<FetchProductEvent, FetchProductState> {
  FetchProductBloc() : super(FetchProductState.initial()) {
    on<FetchProductEvent>((event, emit) async {
      switch (event) {
        case FetchProducts(categoryString: String category):
          await _fetchProduct(emit, category);
      }
    });
  }

  Future<void> _fetchProduct(
      Emitter<FetchProductState> emit, String categoryString) async {
    int pageSize = 10;
    String? startAfterName;
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getPaginatedProducts');
      final response = await callable.call(<String, dynamic>{
        'pageSize': pageSize,
        if (startAfterName != null) 'startAfterName': startAfterName,
      });

      final data = response.data;

      List<dynamic> products = data['products'];
      print(products);
      String? nextPageToken = data['nextPageToken'];
      List<Product> productList = products
          .map((item) => Product.fromMap(Map<String, dynamic>.from(item)))
          .toList();

      emit(state.copyWith(products: productList, isLoading: false));

      if (nextPageToken != null) {
        print('Next page token: $nextPageToken');
        // Store it to fetch the next page
      }
    } on FirebaseFunctionsException catch (e) {
      print('Functions Exception: ${e.code} - ${e.message}');
    } catch (e) {
      print('Unknown error: $e');
    }
  }
}
