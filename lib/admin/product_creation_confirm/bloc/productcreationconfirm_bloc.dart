import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_app/database_service.dart/db_service.dart';
import 'package:grocery_app/service_locator/service_locator.dart';

import '../../../database_service.dart/IDBService.dart';
import '../../../models/product/productt.dart';

part 'productcreationconfirm_event.dart';
part 'productcreationconfirm_state.dart';

class ProductcreationconfirmBloc
    extends Bloc<ProductCreationConfirmEvent, ProductCreationConfirmState> {
  IDBService dbService = ServiceLocator().get<DBService<Productt>>();
  ProductcreationconfirmBloc() : super(ProductCreationConfirmState.initial()) {
    on<ProductCreationConfirmEvent>((event, emit) async {
      switch (event) {
        case ProductCreated(id: String productId):
          await _getCreatedProduct(emit, productId);
      }
    });
  }
  Future<void> _getCreatedProduct(
      Emitter<ProductCreationConfirmState> emit, String id) async {
    try {
      emit(state.copyWith(isFetching: true));
      Productt? product = await dbService.getById(id);
      if (product == null) {
        throw Exception("Cannot fetch product");
      }
      emit(state.copyWith(product: product, isFetching: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString(), isFetching: false));
    } finally {
      emit(state.copyWith(isFetching: false));
    }
  }
}
