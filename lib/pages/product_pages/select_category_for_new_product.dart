import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/bloc/new_product/bloc/new_product_bloc.dart';
import 'package:grocery_app/models/category.dart';
import 'package:grocery_app/widgets/category_card.dart';
import 'package:grocery_app/widgets/error_widget.dart';

class SelectCategoryNewProduct extends StatefulWidget {
  const SelectCategoryNewProduct({super.key});

  @override
  State<SelectCategoryNewProduct> createState() =>
      _SelectCategoryNewProductState();
}

class _SelectCategoryNewProductState extends State<SelectCategoryNewProduct> {
  @override
  void initState() {
    super.initState();
    context.read<NewProductBloc>().add(FetchCategoriesForNewProduct());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NewProductBloc, NewProductState>(
          builder: (context, state) {
        if (state.isLoading && state.categories.isEmpty) {}
        if (state.error != null) {
          return Center(
            child: AppErrorWidget(
                message: "Something went wrong in fetching categories",
                onRetry: () {}),
          );
        }
        return RefreshIndicator.adaptive(
          onRefresh: () async => context.read<NewProductBloc>().add(
                FetchCategoriesForNewProduct(),
              ),
          child: ListView.builder(
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                return CategoryCard(
                  category: state.categories[index],
                  onTap: () {
                    context.read<NewProductBloc>().add(
                          NewProductSelectCategoryEvent(
                              category: state.categories[index]),
                        );
                    Navigator.pop(context);
                  },
                );
              }),
        );
      }),
    );
  }
}
