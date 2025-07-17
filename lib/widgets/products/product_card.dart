import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/change_variation/bloc/change_variation_bloc.dart';
import 'package:grocery_app/widgets/cart/product_in_cart.dart';
import '../../models/product/productt.dart';
import '../../utils/screen_utils.dart';
import 'show_modal_bottom_sheet.dart';

class ProductCard extends StatefulWidget {
  Productt product;
  final Widget Function(BuildContext context, Variation variation)?
      buildCartAction;
  ProductCard(
      {super.key, required this.product, required this.buildCartAction});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late Productt product;
  late Variation v;
  late String variationId;

  @override
  void initState() {
    super.initState();
    product = widget.product;
    v = product.variations[0]; // <-- directly set it!
    variationId = v.id!;

    context
        .read<ChangeVariationBloc>()
        .add(ChangeVariation(variationId: variationId));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenUtils.getScreenWidth(context);
    final screenHeight = ScreenUtils.getScreenHeight(context);

    return BlocBuilder<ChangeVariationBloc, ChangeVariationState>(
      builder: (context, state) {
        print(state.variationId);
        if (state.variationId != null) {
          print("hurray man hurray");
          print(state.variationId);

          print("hurray ****");
        }
        String? variationId = state.variationId;

        // Fallback to default if none in bloc
        final variation = product.getVariation(variationId ?? v.id!);

        return SizedBox(
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
                        variation.images.isNotEmpty
                            ? Image.network(
                                variation.images[0],
                                fit: BoxFit.fitHeight,
                                width: double.infinity,
                                height: screenHeight * 0.17,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image),
                              )
                            : Container(color: Colors.grey),
                        widget.buildCartAction != null &&
                                product.variations.length < 2
                            ? Positioned(
                                bottom: screenHeight * 0.005,
                                right: screenWidth * 0.009,
                                child: SizedBox(
                                  height: screenHeight * 0.03,
                                  width: screenWidth * 0.15,
                                  child: widget.buildCartAction!(
                                      context, variation),
                                ),
                              )
                            : Positioned(
                                bottom: screenHeight * 0,
                                right: screenWidth * 0.009,
                                child: SizedBox(
                                  height: screenHeight * 0.04,
                                  width: screenWidth * 0.13,
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottom(context, product,
                                          widget.buildCartAction, () {});
                                    },
                                    child: ProductInCart(
                                      productId: product.id!,
                                      options:
                                          "${product.variations.length} Options",
                                    ),
                                  ),
                                ),
                              ),
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
                                "${variation.unitSize}${variation.unitOfMeasure}",
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
                                borderRadius:
                                    BorderRadius.circular(screenHeight * 0.006),
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
                        variation.name,
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
                          variation.discount.toString(),
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
                          variation.sellingPrice.round().toString(),
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
                              variation.mrp.toString(),
                              style: TextStyle(
                                fontSize: 9,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottom(
                          context, product, widget.buildCartAction, () {});
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Text(
                            "${variation.unitSize} ${variation.unitOfMeasure}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.green,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
