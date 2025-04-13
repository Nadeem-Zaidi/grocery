import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/products/cart/cart_bloc.dart';
import '../models/cart/cart_model.dart';
import '../models/product/product.dart';

Widget addToCartButton(
    Product product, CartItem? cartItem, BuildContext context,
    [Key? trackKey = null]) {
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
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Product info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${product.quantityInBox} ${product.unit}",
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
                            product.sellingPrice!.round().toString(),
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
                            product.mrp.toString(),
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
                          // Decrease button
                          IconButton(
                            color: Colors.white,
                            onPressed: () {
                              context
                                  .read<CartBloc>()
                                  .add(CartItemRemoved(product.id!));
                            },
                            icon: Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                            splashRadius: 20,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),

                          // Quantity
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              cartItem.quantity.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),

                          // Increase button
                          IconButton(
                            onPressed: () {
                              context
                                  .read<CartBloc>()
                                  .add(CartItemAdded(product.id!));
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            splashRadius: 20,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () {
                          context
                              .read<CartBloc>()
                              .add(CartItemAdded(product.id!));
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
            context.read<CartBloc>().add(CartItemAdded(product.id!));
          },
          child: Text("Add To Cart"));
}
