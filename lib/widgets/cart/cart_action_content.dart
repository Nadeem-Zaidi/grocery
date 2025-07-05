import 'package:flutter/material.dart';

import 'add_button.dart';
import 'cart_increment_decrement.dart';

class CartActionContent extends StatelessWidget {
  final String productId;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const CartActionContent({
    super.key,
    required this.productId,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (quantity > 0) {
      return CartIncrementDecrement(
        productId: productId,
        quantity: quantity,
        onAdd: onAdd,
        onRemove: onRemove,
      );
    } else {
      return AddToCartButton(
        backGroundColor: Colors.white,
        fontSize: 12,
        buttonText: "Add",
        addToCart: onAdd,
      );
    }
  }
}
