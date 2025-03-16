import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/categories/create_category_bloc/category_create_bloc.dart';

class CategoryStringpath extends StatefulWidget {
  const CategoryStringpath({super.key});

  @override
  State<CategoryStringpath> createState() => _CategoryStringpathState();
}

class _CategoryStringpathState extends State<CategoryStringpath> {
  @override
  Widget build(BuildContext context) {
    print("Runnning CategoryStringPathString");
    return BlocBuilder<CreateCategoryBloc, CreateCategoryState>(
        builder: (context, state) {
      if (state.path != "") {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.green.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(state.path ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
            ),
            IconButton(
                onPressed: () {
                  context.read<CreateCategoryBloc>().add(ResetPatg());
                },
                icon: Icon(
                  Icons.refresh,
                  color: Theme.of(context).primaryColor,
                ))
          ],
        );
      }

      return Text("");
    });
  }
}
