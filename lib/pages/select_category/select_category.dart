import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../blocs/categories/create_category_bloc/category_create_bloc.dart';
import '../../blocs/categories/fetch_category_bloc/fetch_category_bloc.dart';
import '../../models/category.dart';

class SelectCategory extends StatefulWidget {
  final Function(Category) onCategorySelect;
  const SelectCategory({
    super.key,
    required this.onCategorySelect,
  });

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  TextEditingController searchController = TextEditingController();
  final _scrollController = ScrollController();
  List<Category> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = maxScroll * 0.9; // Load more when 90% scrolled

    if (currentScroll >= threshold &&
        !context.read<FetchCategoryBloc>().state.hasReachedMax) {
      context.read<FetchCategoryBloc>().add(FetchCategories());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FetchCategoryBloc, FetchCategoryState>(
        builder: (context, state) {
          if (state.isFetching && state.categories.isEmpty) {
            return _buildShimmerLoading();
          }

          if (state.error != null) {
            return _buildErrorState(context);
          }

          final categories = searchController.text.isEmpty
              ? state.categories
              : filteredCategories;

          if (categories.isEmpty) {
            return _buildEmptyState(context, state.categories.isEmpty);
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<FetchCategoryBloc>().add(FetchCategories());
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  snap: false,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search categories...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            filteredCategories = state.categories
                                .where(
                                  (cat) => cat.name!.toLowerCase().contains(
                                        value.toLowerCase(),
                                      ),
                                )
                                .toList();
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildCategoryItem(categories[index]),
                    childCount: categories.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          pinned: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            childCount: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text("Failed to load categories"),
          TextButton(
            onPressed: () {
              context.read<FetchCategoryBloc>().add(FetchCategories());
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isInitialEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.category, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(isInitialEmpty ? "No categories found" : "No results found"),
          if (!isInitialEmpty)
            TextButton(
              onPressed: () {
                searchController.clear();
                setState(() {});
              },
              child: const Text("Clear search"),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(Category category) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: category.url != null
            ? CircleAvatar(backgroundImage: NetworkImage(category.url!))
            : CircleAvatar(child: Text(category.name![0])),
        title: Text(category.name!),
        subtitle: Text(category.path!),
        onTap: () {
          widget.onCategorySelect(category);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
