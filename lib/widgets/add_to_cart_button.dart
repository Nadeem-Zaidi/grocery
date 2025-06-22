import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/widgets/cart_increment_decrement.dart';

import '../blocs/products/cart/cart_bloc.dart';
import '../models/cart/cart_model.dart';
import '../models/product/product.dart';
import '../models/product/productt.dart';

Widget addToCartButton(
    Productt product, CartItem? cartItem, BuildContext context,
    [Key? trackKey]) {
  return cartItem != null
      ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
            // borderRadius: const BorderRadius.only(
            //   topLeft: Radius.circular(16),
            //   topRight: Radius.circular(16),
            // ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Product info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${product.attributes["quantityunit"]} ${product.attributes["unit"]}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Current price
                      Row(
                        children: [
                          const Icon(
                            Icons.currency_rupee,
                            size: 18,
                          ),
                          Text(
                            product.attributes["sellingprice"]!
                                .round()
                                .toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      // MRP with strike-through
                      Row(
                        children: [
                          Text(
                            "MRP ",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            product.attributes["mrp"].toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // Quantity controls
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: cartItem.quantity > 0
                    ? Row(
                        children: [
                          SizedBox(
                            child: CartIncrementDecrement(
                              productId: product.attributes["id"],
                              quantity: cartItem.quantity,
                              height: 50,
                              width: 150,
                            ),
                          )
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () {
                          context
                              .read<CartBloc>()
                              .add(CartItemAdded(product.attributes["id"]!));
                        },
                        child: Text("Add To Cart"),
                      ),
              ),
            ],
          ),
        )
      : ElevatedButton(
          key: trackKey,
          onPressed: () {
            context
                .read<CartBloc>()
                .add(CartItemAdded(product.attributes["id"]!));
          },
          child: Text("Add To Cart"));
}
