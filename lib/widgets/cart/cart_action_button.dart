import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/change_variation/bloc/change_variation_bloc.dart';
import 'package:grocery_app/pages/created_products/variation_card.dart';

import '../../blocs/products/cart/cart_bloc.dart';
import '../../models/product/productt.dart';
import 'add_to_cart_button.dart';
import 'cart_action_content.dart';

class CartActionButton extends StatelessWidget {
  final Variation variation;
  final bool withDetail;

  const CartActionButton(
      {super.key, required this.variation, this.withDetail = false});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listenWhen: (previous, current) => previous.items != current.items,
      listener: (context, state) {},
      builder: (context, state) {
        final productInCart = state.items[variation.id];
        final quantity = productInCart?.quantity ?? 0;

        return !withDetail
            ? CartActionContent(
                productId: variation.id!,
                quantity: quantity,
                onAdd: () {
                  context
                      .read<CartBloc>()
                      .add(CartItemAdded(variation: variation));
                },
                onRemove: () {
                  context.read<CartBloc>().add(CartItemRemoved(variation.id!));
                },
              )
            : AddToCartInProductDescription(
                variation: variation,
                cartItem: productInCart,
                cartAction: CartActionContent(
                  productId: variation.id!,
                  quantity: quantity,
                  onAdd: () {
                    context
                        .read<CartBloc>()
                        .add(CartItemAdded(variation: variation));
                  },
                  onRemove: () {
                    context
                        .read<CartBloc>()
                        .add(CartItemRemoved(variation.id!));
                  },
                ),
              );
      },
    );
  }
}
