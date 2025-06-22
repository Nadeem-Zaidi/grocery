import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_app/models/product/productt.dart';
import 'package:meta/meta.dart';

import '../../../database_service.dart/IDBService.dart';
import '../../../database_service.dart/idatabase_service.dart';
import '../../../models/category.dart';
import '../../../models/product/product.dart';

part 'fetch_category_event.dart';
part 'fetch_category_state.dart';

class FetchCategoryBloc extends Bloc<FetchCategoryEvent, FetchCategoryState> {
  final IdatabaseService dbService;
  final IDBService<Productt> productService;

  FetchCategoryBloc(this.dbService, this.productService)
      : super(FetchCategoryState.initial()) {
    on<FetchCategoryEvent>((event, emit) async {
      switch (event) {
        case FetchCategories():
          await _onFetchCategories(emit);

        case FetchCategoryChildren(
            categoryId: String id,
            categoryName: String name
          ):
          await _fetchCategoryChildren(emit, id, name);
        case FetchProductWithChildren():
          await _fetchCategoriesWithProduct(emit);
        case SetCurrentChild(name: String n):
          await seCurrentChildCat(emit, n);

        case FetchNext():
          await fetchNext(emit);
      }
    });
  }

  Future<void> _fetchCategoryChildren(
      Emitter<FetchCategoryState> emit, String id, String name) async {
    try {
      emit(state.copyWith(isFetching: true));
      var (childCategories, lastDoc, hasReachedMax) =
          await dbService.whereClause(
              (collection) => collection.where('parent', isEqualTo: id));

      emit(state.copyWith(
          childrenCategories: childCategories as List<Category>,
          defaultChildCat: childCategories[0].name,
          currentChildCat: childCategories[0].name,
          categoryName: name,
          isFetching: false));
      add(FetchProductWithChildren());
    } catch (e) {
      print("Can not fetch the child category due to error ==> $e");
      emit(state.copyWith(isFetching: false, error: e.toString()));
    }
  }

  Future<void> _fetchCategoriesWithProduct(
      Emitter<FetchCategoryState> emit) async {
    // Don't fetch if already loading

    try {
      emit(state.copyWith(
        isFetching: true,
        // Reset these for new category
        products: [],
        lastProductDocument: null,
        hasReachedProductMax: false,
      ));
      print("here");

      var (products, lastDocument, hasReachedMax) =
          await productService.whereClause(
        (collection) => collection
            .where("categoryname", isEqualTo: state.currentChildCat)
            .orderBy("name")
            .limit(10),
      );

      emit(state.copyWith(
        products: products,
        lastProductDocument: lastDocument,
        isFetching: false,
        hasReachedProductMax: hasReachedMax,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isFetching: false,
      ));
    }
  }

  Future<void> fetchNext(Emitter<FetchCategoryState> emit) async {
    // Don't fetch if already loading, no more products, or no last document
    if (state.isFetching ||
        state.hasReachedProductMax ||
        state.lastProductDocument == null) {
      return;
    }

    try {
      emit(state.copyWith(isFetching: true));

      var (newProducts, lastDocument, hasReachedMax) =
          await productService.whereClause(
        (collection) => collection
            .where("categoryname", isEqualTo: state.currentChildCat)
            .orderBy("name")
            .startAfterDocument(state.lastProductDocument!)
            .limit(10),
        state.lastProductDocument, // Pass the last document
      );

      emit(state.copyWith(
        products: [...state.products, ...newProducts],
        lastProductDocument: lastDocument,
        isFetching: false,
        hasReachedProductMax: hasReachedMax,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isFetching: false,
      ));
    }
  }

  Future<void> seCurrentChildCat(
      Emitter<FetchCategoryState> emit, String? name) async {
    emit(state.copyWith(currentChildCat: name));
    add(FetchProductWithChildren());
  }

  Future<void> _onFetchCategories(
    Emitter<FetchCategoryState> emit,
  ) async {
    // Don't fetch if we're already loading or have reached max
    if (state.isFetching || state.hasReachedMax) return;

    emit(state.copyWith(isFetching: true));

    try {
      final (newCategories, newLastDocument) = await dbService.getAll(
        10, // Your page size
        state.lastDocument, // Pass the last document for pagination
      );

      if (newCategories.isEmpty) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        emit(state.copyWith(
          categories: [...state.categories, ...newCategories],
          lastDocument: newLastDocument,
        ));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isFetching: false));
    }
  }
}
