import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/products/cart/cart_bloc.dart';
import '../../models/product/productt.dart';
import 'add_to_cart_button.dart';
import 'cart_action_content.dart';

class CartActionButton extends StatelessWidget {
  final product;
  final bool withDetail;

  const CartActionButton(
      {super.key, required this.product, this.withDetail = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final productInCart = state.items[product.id!];
        final quantity = productInCart?.quantity ?? 0;

        return !withDetail
            ? CartActionContent(
                productId: product.id!,
                quantity: quantity,
                onAdd: () {
                  context.read<CartBloc>().add(CartItemAdded(product.id!));
                },
                onRemove: () {
                  context.read<CartBloc>().add(CartItemRemoved(product.id!));
                },
              )
            : AddToCartInProductDescription(
                product: product,
                cartItem: productInCart,
                cartAction: CartActionContent(
                  productId: product.id!,
                  quantity: quantity,
                  onAdd: () {
                    context.read<CartBloc>().add(CartItemAdded(product.id!));
                  },
                  onRemove: () {
                    context.read<CartBloc>().add(CartItemRemoved(product.id!));
                  },
                ),
              );
      },
    );
  }
}
