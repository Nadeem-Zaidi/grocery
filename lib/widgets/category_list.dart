import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/categories/fetch_category_bloc/fetch_category_bloc.dart';

import '../models/category.dart';

class CategoryList extends StatefulWidget {
  final List<Category> categories;
  const CategoryList({super.key, required this.categories});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    List<Category> childrenCat = widget.categories;
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: childrenCat.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            context
                .read<FetchCategoryBloc>()
                .add(SetCurrentChild(childrenCat[index].name!));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            decoration: BoxDecoration(
                // color: isSelected
                //     ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                //     : Colors.transparent,
                // border: isSelected
                //     ? Border(
                //         left: BorderSide(
                //           color: Theme.of(context).colorScheme.primary,
                //           width: 3,
                //         ),
                //       )
                //     : null,
                ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Category Image
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    // color: isSelected
                    //     ? Theme.of(context).colorScheme.primaryContainer
                    //     : Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  child: childrenCat[index].url != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            childrenCat[index].url!,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.category,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.category,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                ),
                const SizedBox(height: 8),
                // Category Name
                Text(
                  childrenCat[index].name ?? "",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    // fontWeight:
                    //     isSelected ? FontWeight.bold : FontWeight.normal,
                    // color: isSelected
                    //     ? Theme.of(context).colorScheme.primary
                    //     : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
