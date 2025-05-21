// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:grocery_app/utils/screen_utils.dart';

// import '../blocs/categories/fetch_category_bloc/fetch_category_bloc.dart';
// import '../blocs/products/cart/cart_bloc.dart';
// import '../blocs/products/fetch_product/fetch_product_bloc.dart';
// import '../models/product/product.dart';
// import '../pages/product_pages/product_detail.dart';
// import 'add_button.dart';
// import 'cart_increment_decrement.dart';

// class BuildProductGrid extends StatefulWidget {
//   final List<Product> products;
//   const BuildProductGrid({super.key, required this.products});

//   @override
//   State<BuildProductGrid> createState() => _BuildProductGridState();
// }

// class _BuildProductGridState extends State<BuildProductGrid> {
//   late ScrollController _scrollController;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//     _scrollController.addListener(_scrollControll);
//   }

//   void _scrollControll() {
//     if (_scrollController.position.pixels ==
//             _scrollController.position.maxScrollExtent &&
//         !context.read<FetchCategoryBloc>().state.hasReachedProductMax) {
//       context.read<FetchCategoryBloc>().add(FetchNext());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = ScreenUtils.getScreenWidth(context);
//     final screenHeight = ScreenUtils.getScreenHeight(context);
//     final isSmallDevice = screenWidth < 360;
//     final isTablet = screenWidth > 600;
//     List<Product> products = widget.products;
//     return GridView.builder(
//       controller: _scrollController,
//       itemCount: products.length,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, childAspectRatio: 0.4),
//       itemBuilder: (context, index) {
//         return InkWell(
//           onTap: () {
//             Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) =>
//                     ProductDetailPage(product: products[index])));
//           },
//           child: SizedBox(
//             height: screenHeight * 0.20,
//             child: Padding(
//               padding: EdgeInsets.all(3),
//               child: Card(
//                 margin: EdgeInsets.all(5),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Stack(
//                       children: [
//                         AspectRatio(
//                           aspectRatio: 0.8,
//                           child: products[index].images[0] != null
//                               ? Image.network(
//                                   products[index].images[0],
//                                   fit: BoxFit.fill,
//                                   width: double.infinity,
//                                   errorBuilder: (context, error, stackTrace) =>
//                                       const Icon(Icons.broken_image),
//                                 )
//                               : Container(color: Colors.grey),
//                         ),
//                         BlocBuilder<CartBloc, CartState>(
//                           builder: (context, state) {
//                             final productInCart =
//                                 state.items[products[index].id];
//                             final quantity = productInCart?.quantity ?? 0;
//                             if (quantity > 0) {
//                               String productId = products[index].id!;
//                               return Positioned(
//                                 bottom: 4,
//                                 right: 0,
//                                 child: SizedBox(
//                                   height: 35,
//                                   child: CartIncrementDecrement(
//                                     productId: productId,
//                                     quantity: quantity,
//                                   ),
//                                 ),
//                               );
//                             }
//                             return Positioned(
//                               bottom: 0,
//                               right: 0,
//                               child: InkWell(
//                                 onTap: () {
//                                   context
//                                       .read<CartBloc>()
//                                       .add(CartItemAdded(products[index].id!));
//                                 },
//                                 child: AddToCartButton(
//                                     height: 30,
//                                     width: 40,
//                                     backGroundColor: Colors.white,
//                                     buttonText: "Add"),
//                               ),
//                             );
//                           },
//                         )
//                       ],
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     SizedBox(
//                       width: double.infinity,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Flexible(
//                             flex: 1,
//                             child: Container(
//                               padding: EdgeInsets.all(2),
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context)
//                                     .primaryColor
//                                     .withValues(alpha: 0.2),
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: Text(
//                                 "${products[index].quantityInBox}${products[index].unit}",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 12),
//                               ),
//                             ),
//                           ),
//                           Flexible(
//                             flex: 3,
//                             child: Container(
//                               padding: EdgeInsets.all(2),
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context)
//                                     .primaryColor
//                                     .withValues(alpha: 0.2),
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: Text(
//                                 "Wheat Atta",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 12),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         products[index].name ?? "",
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.timelapse,
//                           size: 15,
//                           color: Theme.of(context)
//                               .primaryColor
//                               .withValues(alpha: 0.7),
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         Text("18 MINS")
//                       ],
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Row(
//                       children: [
//                         Text(
//                           products[index].discount.toString(),
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Theme.of(context).primaryColor),
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         Text(
//                           "OFF",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Theme.of(context).primaryColor),
//                         )
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Icon(Icons.currency_rupee),
//                         Text(
//                           products[index].sellingPrice!.round().toString(),
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                         SizedBox(width: 7),
//                         Row(
//                           children: [
//                             Text(
//                               "MRP",
//                               style: TextStyle(fontSize: 12),
//                             ),
//                             SizedBox(width: 3),
//                             Text(
//                               products[index].mrp!.round().toString(),
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 decoration: TextDecoration.lineThrough,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
