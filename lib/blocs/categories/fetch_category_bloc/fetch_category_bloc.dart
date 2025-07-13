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
  final IDBService<Category> dbService;
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
        case SelectProductCategory(category: Category c):
          await _selectCategory(emit, c);
        case ProductWithCategory(name: String categoryString):
          await _fetchProductWithCategory(emit, categoryString);
      }
    });
  }

  Future<void> _fetchCategoryChildren(
      Emitter<FetchCategoryState> emit, String id, String name) async {
    try {
      emit(state.copyWith(categoryLoading: true));
      var (childCategories, lastDoc, hasReachedMax) =
          await dbService.whereClause(
              (collection) => collection.where('parent', isEqualTo: id));

      emit(state.copyWith(
          childrenCategories: childCategories as List<Category>,
          defaultChildCat: childCategories[0].name,
          currentChildCat: childCategories[0].name,
          categoryName: name,
          categoryLoading: false));
      add(FetchProductWithChildren());
    } catch (e) {
      print("Can not fetch the child category due to error ==> $e");
      emit(state.copyWith(categoryLoading: false, error: e.toString()));
    }
  }

  Future<void> _fetchCategoriesWithProduct(
    Emitter<FetchCategoryState> emit,
  ) async {
    List<Productt> productResult = [];
    try {
      emit(state.copyWith(
        productLoading: true,
        products: [],
        lastProductDocument: null,
        hasReachedProductMax: false,
      ));

      var (products, lastDocument, hasReachedMax) =
          await productService.whereClause(
        (collection) => collection
            .where("categoryname", isEqualTo: state.currentChildCat)
            .orderBy("name")
            .limit(10),
      );

      final firestore = productService.getFireStore();

      for (var p in products) {
        p.variations ??= [];

        final collRef =
            firestore.collection("products").doc(p.id).collection("variations");
        final qs = await collRef.get();

        if (qs.docs.isNotEmpty) {
          for (var doc in qs.docs) {
            p.variations.add(
              Variation.fromMap({"id": doc.id, ...doc.data()}),
            );
          }
        }

        productResult = [...productResult, p];
      }

      emit(state.copyWith(
        products: productResult,
        lastProductDocument: lastDocument,
        productLoading: false,
        hasReachedProductMax: hasReachedMax,
      ));
    } catch (e, stk) {
      print(e);
      print(stk);
      emit(state.copyWith(
        error: e.toString(),
        productLoading: false,
      ));
    }
  }

  Future<void> fetchNext(Emitter<FetchCategoryState> emit) async {
    // Don't fetch if already loading, no more products, or no last document
    if (state.productLoading ||
        state.hasReachedProductMax ||
        state.lastProductDocument == null) {
      return;
    }

    try {
      emit(state.copyWith(productLoading: true));

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
        productLoading: false,
        hasReachedProductMax: hasReachedMax,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        productLoading: false,
      ));
    }
  }

  Future<void> seCurrentChildCat(
      Emitter<FetchCategoryState> emit, String? name) async {
    if (state.currentChildCat != name) {
      emit(state.copyWith(currentChildCat: name));
      add(FetchProductWithChildren());
    }
  }

  Future<void> _onFetchCategories(
    Emitter<FetchCategoryState> emit,
  ) async {
    // Don't fetch if we're already loading or have reached max
    if (state.categoryLoading || state.hasReachedMax) return;

    emit(state.copyWith(categoryLoading: true));

    try {
      final (newCategories, newLastDocument) = await dbService.getAll(
        10,
        "name",
        state.lastDocument,
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
      emit(state.copyWith(categoryLoading: false));
    }
  }

  Future<void> _selectCategory(
      Emitter<FetchCategoryState> emit, Category category) async {
    try {
      print("from inside selected category");
      print(category.id);
      print("from inside selected category");
      emit(state.copyWith(selectedCategory: category));
      add(ProductWithCategory(category.name!));
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Future<void> _fetchProductWithCategory(
      Emitter<FetchCategoryState> emit, String categoryString) async {
    List<Productt> productResult = [];
    try {
      emit(state.copyWith(
        productLoading: true,
        products: [],
        lastProductDocument: null,
        hasReachedProductMax: false,
      ));

      var (products, lastDocument, hasReachedMax) =
          await productService.whereClause(
        (collection) => collection
            .where("categoryname", isEqualTo: state.currentChildCat)
            .orderBy("name")
            .limit(10),
      );

      final firestore = productService.getFireStore();

      for (var p in products) {
        p.variations ??= [];

        final collRef =
            firestore.collection("products").doc(p.id).collection("variations");
        final qs = await collRef.get();

        if (qs.docs.isNotEmpty) {
          for (var doc in qs.docs) {
            p.variations.add(
              Variation.fromMap({"id": doc.id, ...doc.data()}),
            );
          }
        }

        productResult = [...productResult, p];
      }

      emit(state.copyWith(
        products: productResult,
        lastProductDocument: lastDocument,
        productLoading: false,
        hasReachedProductMax: hasReachedMax,
      ));
    } catch (e, stk) {
      print(e);
      print(stk);
      emit(state.copyWith(
        error: e.toString(),
        productLoading: false,
      ));
    }
  }
}
