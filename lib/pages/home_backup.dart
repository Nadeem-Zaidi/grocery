import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/authentication/cubit/auth_cubit.dart';
import 'package:grocery_app/blocs/categories/fetch_category_bloc/fetch_category_bloc.dart';
import 'package:grocery_app/blocs/dashboard_builder/cubit/dashboard_builder_cubit.dart';
import 'package:grocery_app/database_service.dart/dashboard/firebase_dashboard_service.dart';
import 'package:grocery_app/database_service.dart/inventory/firebase_inventory_service.dart';
import 'package:grocery_app/database_service.dart/product/firestore_product_service.dart';
import 'package:grocery_app/models/category.dart';
import 'package:grocery_app/models/sections/section.dart';
import 'package:grocery_app/pages/product_pages/product_list_builder.dart';
import 'package:grocery_app/widgets/category_drawer.dart';
import 'package:grocery_app/widgets/category_list.dart';
import 'package:grocery_app/widgets/shop_by_store.dart';
import 'package:grocery_app/widgets/sliver_category.dart';
import 'package:permission_handler/permission_handler.dart';
import '../database_service.dart/db_service.dart';
import '../models/product/productt.dart';
import '../service_locator/service_locator.dart';
import '../widgets/cart/cart_action_button.dart';
import '../widgets/products/build_product_grid.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _searchBarKey = GlobalKey();

  FirestoreProductService productService = FirestoreProductService(
    fireStore: FirebaseFirestore.instance,
    collectionName: "products",
  );

  FirestoreInventoryService inventoryService = FirestoreInventoryService(
    fireStore: FirebaseFirestore.instance,
    collectionName: "inventory",
  );

  FirebaseDashBoard dashBoardService = FirebaseDashBoard(
    FirebaseFirestore.instance,
  );

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !context.read<DashboardBuilderCubit>().state.hasReachedMax) {
      context.read<DashboardBuilderCubit>().fetchSections();
    }
  }

  void _checkSearchBarPosition() {}

  Future<Map<String, double>?> getLocation() async {
    // 1. Check if permission is already granted
    // var status = await Permission.location.status;
    // if (!status.isGranted) {
    //   // 2. Request permission if not granted
    //   status = await Permission.location.request();
    //   if (!status.isGranted) {
    //     print("Location permission permanently denied");
    //     return null;
    //   }
    // }

    // 3. Only call native code AFTER permission is confirmed
    try {
      Map<String, dynamic> location = await LocationService.getLocation();

      return {
        'latitude': location['latitude'],
        'longitude': location['longitude'],
      };
    } catch (e) {
      print("Location fetch error: $e");
      return null;
    }
  }

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
        drawer: const CategoryDrawer(),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Delivery in",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "10 minutes",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.person,
                              size: 36,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Home",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: const [
                              Text(
                                "Niknampur Road",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(Icons.arrow_drop_down, color: Colors.white),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(100),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Corrected BlocBuilder
            BlocBuilder<DashboardBuilderCubit, DashboardBuilderState>(
              builder: (context, state) {
                if (state.sections.isEmpty) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
                if (state.sections.isEmpty && state.isLoading) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                // Build slivers dynamically
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final Section category = state.sections[index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min, // Add this
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          _buildHeader(category.type!, category.name!),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: category.elements.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 2 / 3,
                            ),
                            itemBuilder: (context, itemIndex) {
                              final items = category.elements;
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider<FetchCategoryBloc>(
                                            create: (context) =>
                                                FetchCategoryBloc(
                                              ServiceLocator()
                                                  .get<DBService<Category>>(),
                                              ServiceLocator().getWithParam<
                                                  DBService<Productt>,
                                                  String>("products"),
                                            )..add(
                                                    FetchCategoryChildren(
                                                        items[itemIndex].id!,
                                                        items[itemIndex].name),
                                                  ),
                                          ),
                                        ],
                                        child: ProductListBuilder(
                                          categoryListWidget: (categories) =>
                                              CategoryList(
                                                  categories: categories),
                                          productListWidget: (products) =>
                                              BuildProductGrid(
                                            products: products,
                                            buildCartAction:
                                                (context, variation) {
                                              return CartActionButton(
                                                  variation: variation);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: _buildSection(
                                    category.type!, items[itemIndex]),
                              );
                            },
                          ),
                        ],
                      );
                    },
                    childCount:
                        state.sections.length + (state.isLoading ? 1 : 0),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildSection(String type, Category category) {
  if (type == "category") {
    return DashboardCategory(category: category);
  }
  if (type == "store") {
    return ShopByStore(category: category);
  }
  return Container();
}

Widget _buildHeader(String type, String name) {
  if (type == "store") {
    return const Text(
      "Shop By Store",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  return Text(
    name,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );
}

class LocationService {
  static const platform = MethodChannel('com.example.grocery_app/location');

  static Future<Map<String, double>> getLocation() async {
    // 1. Request location permission
    var status = await Permission.location.request();

    if (!status.isGranted) {
      throw 'Location permission not granted';
    }

    // 2. Call Kotlin native code
    try {
      final result = await platform.invokeMethod<Map>('getDeviceLocation');
      return {
        'latitude': result?['latitude'] ?? 0.0,
        'longitude': result?['longitude'] ?? 0.0,
      };
    } on PlatformException catch (e) {
      throw 'Location fetch error: ${e.message}';
    }
  }
}
