import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/categories/category_parent_dialog_bloc/cubit/category_parent_dialog_cubit.dart';

import '../blocs/products/product_bloc/product_bloc.dart';
import '../models/category.dart';

Future<void> categorySelectionForProduct(
    BuildContext context, double width, double height) {
  final categoryParentDialogCubit = context.read<CategoryParentDialogCubit>();
  final productBloc = context.read<ProductBloc>();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: categoryParentDialogCubit),
          BlocProvider.value(value: productBloc)
        ],
        child: Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(width * 0.012)),
          child: SizedBox(
            height: height * 0.6,
            width: double.infinity,
            child: BlocBuilder<CategoryParentDialogCubit,
                CategoryParentDialogState>(
              builder: (context, state) {
                if (state.categories.isNotEmpty) {
                  var categories = state.categories as List<Category>;

                  return ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            context
                                .read<ProductBloc>()
                                .add(SetCategory(categories[index].path ?? ""));
                            Navigator.of(context).pop();
                          },
                          child: ListTile(
                            title: Text(categories[index].name ?? ""),
                            subtitle: Text(categories[index].path ?? ""),
                          ),
                        );
                      });
                }
                return Container();
              },
            ),
          ),
        ),
      );
    },
  );
}
