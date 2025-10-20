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
import 'package:grocery_app/widgets/category_list.dart';
import 'package:grocery_app/widgets/shop_by_store.dart';
import 'package:grocery_app/widgets/sliver_category.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../database_service.dart/db_service.dart';
import '../../models/product/productt.dart';
import '../../service_locator/service_locator.dart';
import '../../widgets/cart/cart_action_button.dart';
import '../../widgets/category_drawer.dart';
import '../../widgets/products/build_product_grid.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  final GlobalKey _searchBarKey = GlobalKey();
  bool _isSearchBarAtTop = false;

  static const double _headerImageHeight = 300;
  static const double _searchBarHeight = 45.0;

  bool get _shouldStick => (_isSearchBarAtTop && _scrollOffset > 100);

  final String _imageUrl =
      'https://img.freepik.com/premium-vector/monsoon-sale_961071-9377.jpg';

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
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !context.read<DashboardBuilderCubit>().state.hasReachedMax) {
      context.read<DashboardBuilderCubit>().fetchSections();
    }
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
    _checkSearchBarPosition();
  }

  void _checkSearchBarPosition() {
    final renderBox =
        _searchBarKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      final screenTop = kToolbarHeight;
      final newAtTop = position.dy < screenTop;
      if (newAtTop != _isSearchBarAtTop) {
        setState(() {
          _isSearchBarAtTop = newAtTop;
        });
      }
    }
  }

  Widget _buildStickyAppBar() {
    return Transform.translate(
      offset: _shouldStick ? const Offset(0, 0) : Offset(0, -_scrollOffset),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.of(context).padding.top,
          16,
          0,
        ),
        decoration: BoxDecoration(
          color: _shouldStick ? Colors.green : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_shouldStick)
              SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("12 Minutes Delivery",
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Row(
                      children: [
                        Text("Home",
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text(" - Last House",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            Container(
              key: _searchBarKey,
              height: _searchBarHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text("Search for atta, dal, coffee...",
                        style: TextStyle(fontSize: 14)),
                  ),
                  Icon(Icons.mic, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryIcon(Icons.widgets, "All"),
                _buildCategoryIcon(Icons.umbrella, "Monsoon"),
                _buildCategoryIcon(Icons.headphones, "Electronics"),
                _buildCategoryIcon(Icons.auto_awesome, "Beauty"),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
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
        backgroundColor: Colors.grey[100],
        body: Stack(
          children: [
            // Background header image
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Transform.translate(
                offset: Offset(0, -_scrollOffset),
                child: SizedBox(
                  height: _headerImageHeight,
                  child: Image.network(
                    _imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Scrollable content
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(height: _headerImageHeight),
                ),
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
                                          builder: (context) =>
                                              MultiBlocProvider(
                                            providers: [
                                              BlocProvider<FetchCategoryBloc>(
                                                create: (context) =>
                                                    FetchCategoryBloc(
                                                  ServiceLocator().get<
                                                      DBService<Category>>(),
                                                  ServiceLocator().getWithParam<
                                                      DBService<Productt>,
                                                      String>("products"),
                                                )..add(
                                                        FetchCategoryChildren(
                                                            items[itemIndex]
                                                                .id!,
                                                            items[itemIndex]
                                                                .name),
                                                      ),
                                              ),
                                            ],
                                            child: ProductListBuilder(
                                              categoryListWidget:
                                                  (categories) => CategoryList(
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
            // Sticky AppBar overlay
            _buildStickyAppBar(),
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
    var status = await Permission.location.request();
    if (!status.isGranted) {
      throw 'Location permission not granted';
    }
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
