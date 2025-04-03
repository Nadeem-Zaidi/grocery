import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/authentication/cubit/auth_cubit.dart';
import 'package:grocery_app/blocs/categories/fetch_category_bloc/fetch_category_bloc.dart';
import 'package:grocery_app/database_service.dart/category/firestore_category_service.dart';
import 'package:grocery_app/database_service.dart/dashboard/firebase_dashboard_service.dart';
import 'package:grocery_app/pages/product_pages/product_list.dart';
import 'package:grocery_app/widgets/category_drawer.dart';
import 'package:shimmer/shimmer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

// 1. Change your state class to be a TickerProviderStateMixin
class _HomeState extends State<Home> with TickerProviderStateMixin {
  List<Map<String, dynamic>> content = [];
  bool _isLoading = true;
  late TabController _tabController; // Add TabController

  Future<void> fetchData() async {
    try {
      FirebaseDashBoard dashBoard =
          FirebaseDashBoard(FirebaseFirestore.instance);
      List<Map<String, dynamic>> rawData = await dashBoard.getAll();

      setState(() {
        content = rawData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error appropriately
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();

    _tabController =
        TabController(length: 6, vsync: this); // Initialize controller
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose controller
    super.dispose();
  }

  // ... keep your existing methods ...

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (p, c) => p.isLoggedIn != c.isLoggedIn && !c.isLoggedIn,
          listener: (context, state) {
            Navigator.of(context).pushReplacementNamed('/signinsignup');
          },
        ),
      ],
      child: Scaffold(
        body: DefaultTabController(
          length: 6, // Number of tabs
          initialIndex: 0,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 250,
                  toolbarHeight: 100,
                  floating: true,
                  pinned: true,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(150.0),
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          padding: EdgeInsets.all(5),
                          child: TextField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                prefix: Icon(
                                  Icons.search,
                                  color: Colors.purple,
                                )),
                          ),
                        ),
                        TabBar(
                          labelColor: Colors.white,
                          controller: _tabController,
                          isScrollable: true,

                          // Enables horizontal scrolling
                          tabs: [
                            Tab(icon: Icon(Icons.home), text: 'Home'),
                            Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
                            Tab(icon: Icon(Icons.person), text: 'Profile'),
                            Tab(icon: Icon(Icons.shopping_cart), text: 'Cart'),
                            Tab(icon: Icon(Icons.settings), text: 'Settings'),
                            Tab(icon: Icon(Icons.info), text: 'About'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                CustomScrollView(
                  slivers: [
                    if (!_isLoading && content.isNotEmpty)
                      ...content
                          .map((category) => [
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      category.keys.first,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    childAspectRatio: 2 / 3,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      var categoryName = category.keys.first;
                                      var items = category[categoryName];

                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MultiBlocProvider(
                                                providers: [
                                                  BlocProvider<
                                                      FetchCategoryBloc>(
                                                    create: (context) =>
                                                        FetchCategoryBloc(
                                                      FirestoreCategoryService(
                                                        firestore:
                                                            FirebaseFirestore
                                                                .instance,
                                                        collectionName:
                                                            "categories",
                                                      ),
                                                    )..add(FetchCategoryChildren(
                                                            items[index]
                                                                ['id'])),
                                                  ),
                                                ],
                                                child: ProductList(),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          margin: EdgeInsets.all(5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: AspectRatio(
                                                  aspectRatio: 1.2,
                                                  child: items[index]['url'] !=
                                                              null &&
                                                          items[index]['url']
                                                              .isNotEmpty
                                                      ? Image.network(
                                                          items[index]['url'],
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
                                                          errorBuilder: (context,
                                                                  error,
                                                                  stackTrace) =>
                                                              const Icon(Icons
                                                                  .broken_image),
                                                        )
                                                      : Container(
                                                          color: Colors.grey),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  items[index]['name'] ??
                                                      'Unnamed',
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    childCount:
                                        category[category.keys.first].length,
                                  ),
                                ),
                              ])
                          .expand((x) => x),
                  ],
                ),
                CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return ListTile(
                          title: Text("Home Content $index"),
                        );
                      }, childCount: 20),
                    )
                  ],
                ),
                // Content for Profile tab
                CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return ListTile(
                          title: Text("Profile Content $index"),
                        );
                      }, childCount: 20),
                    )
                  ],
                ),
                CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return ListTile(
                          title: Text("Profile Content $index"),
                        );
                      }, childCount: 20),
                    )
                  ],
                ),
                CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return ListTile(
                          title: Text("Profile Content $index"),
                        );
                      }, childCount: 20),
                    )
                  ],
                ),
                CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return ListTile(
                          title: Text("Profile Content $index"),
                        );
                      }, childCount: 20),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        drawer: const CategoryDrawer(),
      ),
    );
  }
}
