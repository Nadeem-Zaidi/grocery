import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/categories/category_update/category_update_bloc.dart';
import 'package:grocery_app/blocs/categories/fetch_category_bloc/fetch_category_bloc.dart';
import 'package:grocery_app/pages/category_pages/category_update_page.dart';
import 'package:grocery_app/pages/category_pages/create_category_page.dart';
import 'package:shimmer/shimmer.dart';
import '../../blocs/categories/create_category_bloc/category_create_bloc.dart';
import '../../database_service.dart/db_service.dart';
import '../../models/category.dart';
import '../../service_locator/service_locator.dart';
import '../../widgets/category_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_widget.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !context.read<FetchCategoryBloc>().state.hasReachedMax) {
      context.read<FetchCategoryBloc>().add(FetchCategories());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories ',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: BlocBuilder<FetchCategoryBloc, FetchCategoryState>(
        builder: (context, state) {
          if (state.categoryLoading && state.categories.isEmpty) {
            return _buildShimmerLoader();
          }

          if (state.error != null) {
            return Center(
              child: AppErrorWidget(
                message: state.error!,
                onRetry: () =>
                    context.read<FetchCategoryBloc>().add(FetchCategories()),
              ),
            );
          }
          //showing empty widget in the case list is empty
          if (state.categories.isEmpty) {
            return EmptyStateWidget(
              title: 'No Categories Found',
              subtitle: 'Add your first category to get started',
              icon: Icons.category_outlined,
            );
          }

          return RefreshIndicator.adaptive(
            onRefresh: () async =>
                context.read<FetchCategoryBloc>().add(FetchCategories()),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index < state.categories.length) {
                          final category = state.categories[index];
                          return CategoryCard(
                            category: category,
                            onTap: () =>
                                _navigateToUpdatePage(context, category),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: CircularProgressIndicator.adaptive(
                                valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      childCount: state.categories.length +
                          (state.categoryLoading ? 1 : 0),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => CreateCategoryBloc(
                    dbService: ServiceLocator().get<DBService<Category>>()),
                child: CreateCategorypage(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      ),
    );
  }

  //this is the ipdate function for categories
  void _navigateToUpdatePage(BuildContext context, Category category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => CategoryUpdateBloc(
                  dbService: ServiceLocator().get<DBService<Category>>())
                ..add(
                  InitializeExisting(
                    id: category.id!,
                    name: category.name!,
                    parent: category.parent!,
                    path: category.path!,
                    url: category.url!,
                  ),
                ),
            ),
          ],
          child: const CategoryUpdatePage(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
