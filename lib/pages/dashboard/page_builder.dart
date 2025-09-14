import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/section/dashboard_bloc/dashboard_bloc.dart';
import 'package:grocery_app/blocs/section/sectopm_bloc/section_builder_bloc.dart';
import 'package:grocery_app/database_service.dart/dashboard/section.dart'
    as db_section;
import 'package:grocery_app/pages/dashboard/section_builder.dart';
import 'package:grocery_app/pages/dashboard/section_template.dart';
import 'package:grocery_app/widgets/utilities_widget/dialog_box/dialog_box_item.dart';
import 'package:grocery_app/widgets/utilities_widget/dialog_box/dialog_box_list_item.dart';

import '../../widgets/utilities_widget/dialog_box/dialogbox_for_template_selection.dart';

class PageBuilder extends StatefulWidget {
  const PageBuilder({super.key});

  @override
  State<PageBuilder> createState() => _PageBuilderState();
}

class _PageBuilderState extends State<PageBuilder> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  final GlobalKey _searchByKey = GlobalKey();
  bool _isSearchBarAtTop = false;

  static const double _headerImageheight = 500;
  static const double _searchbarheight = 45.0;
  bool get _shouldStick => (_isSearchBarAtTop && _scrollOffset > 100);
  final String _imageUrl =
      'https://img.freepik.com/premium-vector/monsoon-sale_961071-9377.jpg';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _checkSearchBarPosition() {
    final renderBox =
        _searchByKey.currentContext?.findRenderObject() as RenderBox?;
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

  void _handleScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });

    _checkSearchBarPosition();
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
              key: _searchByKey,
              height: _searchbarheight,
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
    return Scaffold(
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {},
        builder: (context, state) {
          List<db_section.Section> section =
              state.dashBoard.sections.values.toList();
          return SizedBox(
            child: Stack(
              children: [
                // Positioned(
                //   top: 0,
                //   left: 0,
                //   right: 0,
                //   child: Transform.translate(
                //     offset: Offset(0, -_scrollOffset),
                //     child: SizedBox(
                //       height: _headerImageheight,
                //       child: Stack(
                //         fit: StackFit
                //             .expand, // makes children fill the available space
                //         children: [
                //           Image.network(
                //             _imageUrl,
                //             fit: BoxFit.cover,
                //           ),
                //           // Example: Gradient overlay
                //           Container(
                //             decoration: BoxDecoration(
                //               gradient: LinearGradient(
                //                 colors: [
                //                   Colors.black.withOpacity(0.4),
                //                   Colors.transparent
                //                 ],
                //                 begin: Alignment.topCenter,
                //                 end: Alignment.bottomCenter,
                //               ),
                //             ),
                //           ),
                //           // Example: Text or widgets on top
                //           Positioned(
                //             bottom: 10,
                //             left: 0,
                //             right: 0,
                //             child: Container(
                //               height: 200,
                //               color: Colors.amber,
                //               child: ListView.builder(
                //                 scrollDirection: Axis.horizontal,
                //                 controller: ScrollController(),
                //                 // physics: const AlwaysScrollableScrollPhysics(),
                //                 itemCount: demoList.length,
                //                 itemBuilder: (context, index) {
                //                   return demoList[index];
                //                 },
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: _headerImageheight,
                        child: Stack(
                          fit: StackFit
                              .expand, // makes children fill the available space
                          children: [
                            Image.network(
                              _imageUrl,
                              fit: BoxFit.cover,
                            ),
                            // Example: Gradient overlay
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.4),
                                    Colors.transparent
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                            // Example: Text or widgets on top
                            Positioned(
                              bottom: 10,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 200,
                                color: Colors.amber,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  controller: ScrollController(),
                                  // physics: const AlwaysScrollableScrollPhysics(),
                                  itemCount: demoList.length,
                                  itemBuilder: (context, index) {
                                    return demoList[index];
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return sectionBuilder(section: section[index]);
                        },
                        childCount: section.length,
                      ),
                    ),
                  ],
                ),

                _buildStickyAppBar()
                // ListView.builder(
                //   itemCount: section.length,
                //   itemBuilder: (context, index) {
                //     return sectionBuilder(section: section[index]);
                //   },
                // ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final parentContext = context;
          showDialog(
              context: parentContext,
              builder: (context) {
                return DialogBoxSectionType(
                  listitems: [
                    ItemWithGoto(
                      name: "Category Section",
                      goTo: () {
                        parentContext.read<DashboardBloc>().add(
                              AddSection(
                                section: db_section.CategorySection(
                                    id: "NZ${DateTime.now().millisecondsSinceEpoch}",
                                    name: "Grocery & Kitchen",
                                    type: 'category',
                                    sequence: 1),
                              ),
                            );
                        Navigator.pop(parentContext);
                      },
                    )
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class PromoCard extends StatelessWidget {
  final String label;
  final String title;
  final String imageUrl;
  final Color labelColor;

  const PromoCard({
    super.key,
    required this.label,
    required this.title,
    required this.imageUrl,
    this.labelColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),

            // Semi-transparent overlay (optional for text readability)
            Container(
              color: Colors.black.withOpacity(0.3),
            ),

            // Top Label
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: labelColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Title Text (center)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> demoList = [
  PromoCard(
    label: "Featured",
    title: "Oxidised Jewelle...",
    imageUrl:
        "https://static.vecteezy.com/system/resources/previews/022/899/918/non_2x/jewelry-ring-with-diamonds-and-precious-stones-ai-generated-free-photo.jpg",
  ),
  PromoCard(
    label: "Festive...",
    title: "Dandiya Specials",
    imageUrl:
        "https://static.vecteezy.com/system/resources/previews/022/899/918/non_2x/jewelry-ring-with-diamonds-and-precious-stones-ai-generated-free-photo.jpg",
    labelColor: Colors.orange,
  ),
  PromoCard(
    label: "Featured",
    title: "Fragrances",
    imageUrl:
        "https://static.vecteezy.com/system/resources/previews/022/899/918/non_2x/jewelry-ring-with-diamonds-and-precious-stones-ai-generated-free-photo.jpg",
  ),
  PromoCard(
    label: "Featured",
    title: "Fragrances",
    imageUrl:
        "https://static.vecteezy.com/system/resources/previews/022/899/918/non_2x/jewelry-ring-with-diamonds-and-precious-stones-ai-generated-free-photo.jpg",
  ),
];
