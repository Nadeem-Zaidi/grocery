import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/change_variation/bloc/change_variation_bloc.dart';
import 'package:grocery_app/utils/screen_utils.dart';
import 'package:grocery_app/widgets/products/product_card.dart';
import '../../blocs/categories/fetch_category_bloc/fetch_category_bloc.dart';
import '../../blocs/products/cart/cart_bloc.dart';
import '../../models/product/productt.dart';
import '../../pages/product_pages/product_detail.dart';

class BuildProductGrid extends StatefulWidget {
  final List<Productt> products;
  final Widget Function(BuildContext context, Variation variation)?
      buildCartAction;

  const BuildProductGrid(
      {super.key, required this.products, this.buildCartAction});

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
    print("Running the Product Builder");

    // final isSmallDevice = screenWidth < 360;
    // final isTablet = screenWidth > 600;
    List<Productt> products = widget.products;
    return GridView.builder(
      controller: _scrollController,
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: screenHeight * 0.00055,
      ),
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                    product: products[index],
                    variation: products[index]
                        .getVariation(products[0].variations[0].id!),
                  ),
                ),
              );
            },
            child: BlocProvider(
              create: (context) => ChangeVariationBloc(),
              child: ProductCard(
                  product: products[0],
                  buildCartAction: widget.buildCartAction),
            ));
      },
    );
  }
}
