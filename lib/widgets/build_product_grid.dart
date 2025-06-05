import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/products/product_detail/product_detail_bloc.dart';
import 'package:grocery_app/database_service.dart/product/firestore_product_service.dart';
import 'package:grocery_app/utils/screen_utils.dart';

import '../blocs/categories/fetch_category_bloc/fetch_category_bloc.dart';
import '../blocs/products/cart/cart_bloc.dart';
import '../models/product/product.dart';
import '../pages/product_pages/product_detail.dart';
import 'add_button.dart';
import 'cart_increment_decrement.dart';

class BuildProductGrid extends StatefulWidget {
  final List<Product> products;
  const BuildProductGrid({super.key, required this.products});

  @override
  State<BuildProductGrid> createState() => _BuildProductGridState();
}

class _BuildProductGridState extends State<BuildProductGrid> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollControll);
  }

  void _scrollControll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !context.read<FetchCategoryBloc>().state.hasReachedProductMax) {
      context.read<FetchCategoryBloc>().add(FetchNext());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenUtils.getScreenWidth(context);
    final screenHeight = ScreenUtils.getScreenHeight(context);
    final isSmallDevice = screenWidth < 360;
    final isTablet = screenWidth > 600;
    List<Product> products = widget.products;
    return GridView.builder(
      controller: _scrollController,
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: screenHeight * 0.0006),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => ProductDetailBloc(
                    dbService: FirestoreProductService(
                        fireStore: FirebaseFirestore.instance,
                        collectionName: "products"),
                  )..add(FetchDetails(products[index].id!)),
                  child: ProductDetailPage(),
                ),
              ),
            );
          },
          child: SizedBox(
            height: screenHeight * 0.20,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.007),
              child: Card(
                margin: EdgeInsets.all(screenWidth * 0.012),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 9,
                      child: Stack(
                        children: [
                          products[index].images[0] != null
                              ? Image.network(
                                  products[index].images[0],
                                  fit: BoxFit.fitHeight,
                                  width: double.infinity,
                                  height: screenHeight * 0.17,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image),
                                )
                              : Container(color: Colors.grey),
                          BlocBuilder<CartBloc, CartState>(
                            builder: (context, state) {
                              final productInCart =
                                  state.items[products[index].id];
                              final quantity = productInCart?.quantity ?? 0;
                              if (quantity > 0) {
                                String productId = products[index].id!;
                                return Positioned(
                                  bottom: screenHeight * 0.005,
                                  right: screenWidth * 0.009,
                                  child: CartIncrementDecrement(
                                    productId: productId,
                                    width: screenHeight * 0.09,
                                    height: screenHeight * 0.035,
                                    quantity: quantity,
                                  ),
                                );
                              }
                              return Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    context.read<CartBloc>().add(
                                        CartItemAdded(products[index].id!));
                                  },
                                  child: AddToCartButton(
                                      height: screenHeight * 0.035,
                                      width: screenHeight * 0.07,
                                      backGroundColor: Colors.white,
                                      fontSize: 12,
                                      buttonText: "Add"),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        height: screenHeight * 0.010,
                      ),
                    ),
                    //product quantity section
                    Flexible(
                      flex: 2,
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  "${products[index].quantityInBox}${products[index].unit}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 8),
                                ),
                              ),
                            ),
                            //product type
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.all(screenHeight * 0.003),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(
                                      screenHeight * 0.006),
                                ),
                                child: Text(
                                  "Wheat Atta",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //product name
                    Flexible(child: SizedBox(height: screenHeight * 0.0010)),
                    Flexible(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          products[index].name ?? "",
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    //delivery time
                    Flexible(
                      child: Row(
                        children: [
                          Icon(
                            Icons.timelapse,
                            size: 800 * 0.015,
                            color: Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.7),
                          ),
                          SizedBox(
                            width: screenHeight * 0.006,
                          ),
                          Text(
                            "18 MINS",
                            style: TextStyle(fontSize: 9),
                          )
                        ],
                      ),
                    ),
                    //vertical gap
                    Flexible(
                      child: SizedBox(
                        height: screenHeight * 0.006,
                      ),
                    ),
                    //discount and off section
                    Flexible(
                      child: Row(
                        children: [
                          Text(
                            products[index].discount.toString(),
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                          SizedBox(
                            width: screenHeight * 0.006,
                          ),
                          Text(
                            "OFF",
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          )
                        ],
                      ),
                    ),
                    //selling price and mrp section
                    Flexible(
                      flex: 2,
                      child: Row(
                        children: [
                          Icon(Icons.currency_rupee),
                          Text(
                            products[index].sellingPrice!.round().toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          SizedBox(width: screenHeight * 0.006),
                          Row(
                            children: [
                              Text(
                                "MRP",
                                style: TextStyle(fontSize: 9),
                              ),
                              SizedBox(width: 3),
                              Text(
                                products[index].mrp!.round().toString(),
                                style: TextStyle(
                                  fontSize: 9,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
