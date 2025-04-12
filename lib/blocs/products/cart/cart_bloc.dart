import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/cart/cart_model.dart';
import '../../../models/cart/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;
  StreamSubscription<Cart>? _cartSubscription;

  CartBloc({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required SharedPreferences prefs,
  })  : _cartRepository = CartRepository(
          firestore: firestore,
          auth: auth,
          prefs: prefs,
        ),
        super(CartState.initial()) {
    on<CartInitRequested>(_onInit);
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartCleared>(_onCleared);
    on<CartSyncRequested>(_onSyncRequested);
  }

  Future<void> _onInit(CartInitRequested event, Emitter<CartState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _cartRepository.init();
      _cartSubscription = _cartRepository.cartStream.listen((cart) {
        add(CartSyncRequested());
      }) as StreamSubscription<Cart>?;
      emit(state.copyWith(
        items: _cartRepository.currentCart.items,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onItemAdded(
      CartItemAdded event, Emitter<CartState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _cartRepository.addToCart(
        productId: event.productId,
        quantity: event.quantity,
      );
      emit(state.copyWith(
        items: _cartRepository.currentCart.items,
        isLoading: false,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onItemRemoved(
      CartItemRemoved event, Emitter<CartState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _cartRepository.decreaseQuantity(event.productId);
      emit(state.copyWith(
        items: _cartRepository.currentCart.items,
        isLoading: false,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onCleared(CartCleared event, Emitter<CartState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _cartRepository.clearCart();
      emit(state.copyWith(
        items: const {},
        isLoading: false,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onSyncRequested(
      CartSyncRequested event, Emitter<CartState> emit) async {
    emit(state.copyWith(
      items: _cartRepository.currentCart.items,
      lastUpdated: DateTime.now(),
    ));
  }

  @override
  Future<void> close() {
    _cartSubscription?.cancel();
    return super.close();
  }
}
