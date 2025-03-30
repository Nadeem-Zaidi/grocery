import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/authentication/cubit/auth_cubit.dart';
import 'package:grocery_app/database_service.dart/dashboard/firebase_dashboard_service.dart';
import 'package:grocery_app/widgets/category_drawer.dart';
import 'package:shimmer/shimmer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> content = [];
  bool _isLoading = true;

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
  }

  Widget _buildShimmerGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 2 / 3,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1.2,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 16,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: 8, // Show 8 shimmer items
      ),
    );
  }

  Widget _buildShimmerCategoryHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 24,
            width: 150,
            color: Colors.white,
          ),
        ),
      ),
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
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery in',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '7 minutes',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        "Home-",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            "Niknampur Road",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              pinned: true,
              toolbarHeight: 100,
              snap: true,
              backgroundColor: Theme.of(context).primaryColor,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(bottom: 5),
                  height: 55,
                  child: TextField(
                    textAlign: TextAlign.justify,
                    decoration: InputDecoration(
                      hintText: "Search",
                      labelStyle: const TextStyle(fontSize: 18),
                      prefixIcon: const Icon(Icons.search),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            if (_isLoading) ...[
              _buildShimmerCategoryHeader(),
              _buildShimmerGrid(),
              _buildShimmerCategoryHeader(),
              _buildShimmerGrid(),
            ],
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

                              return Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: AspectRatio(
                                        aspectRatio: 1.2,
                                        child: items[index]['url'] != null &&
                                                items[index]['url'].isNotEmpty
                                            ? Image.network(
                                                items[index]['url'],
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    const Icon(
                                                        Icons.broken_image),
                                              )
                                            : Container(color: Colors.grey),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        items[index]['name'] ?? 'Unnamed',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            childCount: category[category.keys.first].length,
                          ),
                        ),
                      ])
                  .expand((x) => x),
          ],
        ),
        drawer: const CategoryDrawer(),
      ),
    );
  }
}
