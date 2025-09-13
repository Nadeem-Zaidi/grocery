import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/models/category.dart';
import 'package:grocery_app/models/product/productt.dart';

import '../../blocs/categories/fetch_category_bloc/fetch_category_bloc.dart';

class ProductListBuilder extends StatefulWidget {
  Widget Function(List<Category>) categoryListWidget;
  Widget Function(List<Productt>) productListWidget;
  ProductListBuilder(
      {super.key,
      required this.categoryListWidget,
      required this.productListWidget});

  @override
  State<ProductListBuilder> createState() => _ProductListBuilderState();
}

class _ProductListBuilderState extends State<ProductListBuilder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<FetchCategoryBloc, FetchCategoryState>(
          builder: (context, state) {
            return Text(state.currentChildCat.toString());
          },
        ),
      ),
      body: Row(
        children: [
          BlocBuilder<FetchCategoryBloc, FetchCategoryState>(
            builder: (context, state) {
              if (state.error != null) {
                return Container();
              }
              if (state.categoryLoading) {
                return CircularProgressIndicator();
              }
              if (state.childrenCategories.isEmpty) {
                return Container();
              }
              return SizedBox(
                width: 50,
                child: widget.categoryListWidget(state.childrenCategories),
              );
            },
          ),
          VerticalDivider(
            thickness: 1,
            width: 1,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(2),
              child: BlocBuilder<FetchCategoryBloc, FetchCategoryState>(
                builder: (context, state) {
                  if (state.error != null) {
                    return Center();
                  }
                  if (state.productLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state.products.isEmpty) {
                    return Center(
                      child: Text("No product found"),
                    );
                  }

                  return widget.productListWidget(state.products);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
