import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/change_variation/bloc/change_variation_bloc.dart';
import 'package:grocery_app/service_locator/service_locator.dart';
import 'package:grocery_app/widgets/cart/product_in_cart.dart';
import '../../models/product/productt.dart';
import '../../utils/screen_utils.dart';
import 'show_modal_bottom_sheet.dart';
import 'variation_in_product_Card.dart';

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
        String? variationId = state.variationId;
        final variation = product.getVariation(variationId ?? v.id!);
        return StreamBuilder<DocumentSnapshot>(
            stream: ServiceLocator()
                .get<FirebaseFirestore>()
                .collection("products")
                .doc(product.id)
                .collection("variations")
                .doc(variation.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.exists) {
                return VariationInProductCard(
                    product: product,
                    variation: Variation.fromMap(
                        snapshot.data!.data() as Map<String, dynamic>),
                    buildCartAction: widget.buildCartAction);
              }
              return SizedBox();
            });
      },
    );
  }
}
