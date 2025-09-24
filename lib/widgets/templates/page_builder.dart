import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/section/dashboard_bloc/dashboard_bloc.dart';
import 'package:grocery_app/blocs/section/sectopm_bloc/section_builder_bloc.dart';
import 'package:grocery_app/database_service.dart/dashboard/section.dart'
    as db_section;
import 'package:grocery_app/widgets/templates/section_builder.dart';
import 'package:grocery_app/widgets/templates/category_section_template.dart';
import 'package:grocery_app/widgets/utilities_widget/dialog_box/dialog_box_item.dart';
import 'package:grocery_app/widgets/utilities_widget/dialog_box/dialog_box_list_item.dart';
import 'package:palette_generator/palette_generator.dart';
import '../../database_service.dart/dashboard/section.dart';
import '../card/custom_card.dart';
import '../utilities_widget/dialog_box/dialogbox_for_template_selection.dart';

class PageBuilder extends StatefulWidget {
  const PageBuilder({super.key});

  @override
  State<PageBuilder> createState() => _PageBuilderState();
}

class _PageBuilderState extends State<PageBuilder> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  final GlobalKey _searchByKey = GlobalKey();
  final GlobalKey _appBarKey = GlobalKey();
  final GlobalKey _appbarListSection = GlobalKey();
  bool _changeColorNormal = false;
  bool _isSearchBarAtTop = false;
  static const double _headerImageheight = 600;
  static const double _searchbarheight = 45.0;
  bool get _shouldStick => (_isSearchBarAtTop && _scrollOffset > 100);

  // final String _imageUrl =
  //     'https://firebasestorage.googleapis.com/v0/b/grocerybynadeem.firebasestorage.app/o/images%2Fimp%2FRectangle%201.png?alt=media&token=886eb902-b5a5-4889-ae61-f7d54c9fb81b';

  Color appBarBackground = Colors.blue;
  Color? dominantColor;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    // _updatePalette();
  }

  // Future<void> _updatePalette() async {
  //   final PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
  //     NetworkImage(_imageUrl),
  //     size: const Size(200, 100),
  //   );

  //   final color = generator.dominantColor?.color ?? Colors.grey;

  //   setState(() {
  //     dominantColor = color;
  //   });

  //   // ✅ safe to use context now, because we scheduled this after the first frame
  //   saveColor(color, context);
  // }

  // Future<void> saveColor(Color color, BuildContext context) async {
  //   String hexColor = '#${color.value.toRadixString(16).padLeft(8, '0')}';
  //   context.read<DashboardBloc>().add(AddColor(color: hexColor));
  // }

  /// Returns the proper text color based on appBarBackground and system theme
  Color getContrastingTextColor(BuildContext context, Color background) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    final luminance = background.computeLuminance();

    if (brightness == Brightness.dark) {
      return Colors.white; // Dark system theme -> white text
    } else {
      // Light system theme -> pick based on background luminance
      return luminance > 0.5 ? Colors.black : Colors.white;
    }
  }

  Color getColorFromString(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'ff$hex'; // assume fully opaque
    return Color(int.parse(hex, radix: 16));
  }

  // Define a gradient instead of a solid color

// Helper to get text color based on the first color of the gradient
  Color getContrastingTextColorFromGradient(BuildContext context, Color color) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    final luminance = color.computeLuminance();

    if (brightness == Brightness.dark) {
      return Colors.white;
    } else {
      return luminance > 0.1 ? Colors.black : Colors.white;
    }
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

  void _checkPromoSectionPosition() {
    final renderBox =
        _appBarKey.currentContext?.findRenderObject() as RenderBox?;
    final appListRenderBox =
        _appbarListSection.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && appListRenderBox != null) {
      final topLeft = renderBox.localToGlobal(Offset.zero);
      final appTopLeft = appListRenderBox.localToGlobal(Offset.zero);

// Bottom-left = top-left + height on Y axis
      final bottomLeft = Offset(topLeft.dx, topLeft.dy + renderBox.size.height);
      final bottomLeftAppbarList =
          Offset(appTopLeft.dx, appTopLeft.dy + appListRenderBox.size.height);

      if (bottomLeft.dy < bottomLeftAppbarList.dy) {
        setState(() {
          _changeColorNormal = true;
        });
      } else {
        setState(() {
          _changeColorNormal = false;
        });
      }

      // print(
      //     "appBar dy==>${bottomLeftAppbarList.dy} || ${bottomLeft.dy}"); // 👈 y-position of bottom edge
    }
  }

  void _handleScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
    _checkSearchBarPosition();
    _checkPromoSectionPosition();
  }

  Widget _buildStickyAppBar(BuildContext context, DashboardState state) {
    bool _shouldStickColor = _shouldStick;
    if (_changeColorNormal) {
      _shouldStickColor = false;
    }
    Color? appBarColor;
    if (state.page.dominantColorAppBar != null) {
      appBarColor = getColorFromString(state.page.dominantColorAppBar!);
    }

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
            color: _shouldStickColor
                ? appBarColor
                : _changeColorNormal
                    ? Theme.of(context).primaryColor
                    : Colors.transparent),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_shouldStick)
              SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "12 Minutes Delivery",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: getContrastingTextColorFromGradient(
                            context, appBarColor ?? Colors.black),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Home",
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: getContrastingTextColorFromGradient(
                                  context, appBarColor ?? Colors.black)),
                        ),
                        Text(
                          " - Last House",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: getContrastingTextColorFromGradient(
                                  context, appBarColor ?? Colors.black)),
                        ),
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
                    child: Text(
                      "Search for atta, dal, coffee...",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Icon(Icons.mic, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              key: _appbarListSection,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryIcon(context, Icons.widgets, "All", appBarColor),
                _buildCategoryIcon(
                    context, Icons.umbrella, "Monsoon", appBarColor),
                _buildCategoryIcon(
                    context, Icons.headphones, "Electronics", appBarColor),
                _buildCategoryIcon(
                    context, Icons.auto_awesome, "Beauty", appBarColor),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(
      BuildContext context, IconData icon, String label, Color? appBarColor) {
    final textColor = getContrastingTextColor(context, appBarBackground);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: textColor, size: 22),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: getContrastingTextColorFromGradient(
                context, appBarColor ?? Colors.black),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(
          thickness: 0.8,
          height: 3,
          color: Colors.grey, //
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
              state.page.sections.values.toList();
          List<db_section.Section> promoSection =
              state.page.promoBanner.values.toList();

          return SizedBox(
            child: Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(
                        key: _appBarKey,
                        height: _headerImageheight,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            state.page.appBarImage != null
                                ? Container(
                                    height: 400,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: FileImage(File(state.page
                                            .appBarImage!.path)), // local image
                                        fit: BoxFit
                                            .cover, // cover, contain, fill, etc.
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                      colors: [
                                        Colors.blue,
                                        Colors.white,
                                        Colors.white
                                      ],
                                      begin: Alignment
                                          .topCenter, // start at the top
                                      end: Alignment.bottomCenter, //
                                    )),
                                  ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: promoSection.isNotEmpty
                                  ? sectionBuilder(
                                      section: state.page.promoBanner.values
                                          .toList()[0])
                                  : SizedBox.shrink(),
                            )
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
                _buildStickyAppBar(context, state)
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
                                section: db_section.CategorySection.initial()),
                          );
                      Navigator.pop(parentContext);
                    },
                  ),
                  ItemWithGoto(
                    name: "Promo Section",
                    goTo: () {
                      parentContext.read<DashboardBloc>().add(AddPromoBanner(
                          section:
                              db_section.AppbarPromotionSection.initial()));
                      Navigator.pop(parentContext);
                    },
                  ),
                  SelectImageWithBlocEvent(
                      addEvent: () {
                        parentContext
                            .read<DashboardBloc>()
                            .add(SelectAppBarImge());
                        Navigator.pop(parentContext);
                      },
                      name: "Select Appbar Image")
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

List<Widget> demoList = [
  PromoCard(
    title: "Top Deals",
    imageUrl:
        "https://firebasestorage.googleapis.com/v0/b/grocerybynadeem.firebasestorage.app/o/images%2Fimp%2Fdietary-supplement-muscletech-whey-protein-isolate-whey-protein_enhanced.jpg?alt=media&token=3cf182b9-4165-4bd4-9739-8b97d2dd0a1b",
  ),
  PromoCard(
    title: "Whey Check In",
    imageUrl:
        "https://firebasestorage.googleapis.com/v0/b/grocerybynadeem.firebasestorage.app/o/images%2Fimp%2F663d9840-58da-4716-8a7d-d93f20daf6ea_1_enhanced.jpeg?alt=media&token=6ea07e09-7215-4cfc-8724-33842b73051a",
  ),
  PromoCard(
      title: "Discount On Supplements",
      imageUrl:
          "https://firebasestorage.googleapis.com/v0/b/grocerybynadeem.firebasestorage.app/o/images%2Fimp%2Fbest-protein-powders-available-refresh-lead-1668468392-jpg_enhanced.webp?alt=media&token=36ac5c8a-2130-4a60-bc77-56d73ba81ade")
];

class SimpleResizableBox extends StatefulWidget {
  const SimpleResizableBox({super.key});

  @override
  State<SimpleResizableBox> createState() => _SimpleResizableBoxState();
}

class _SimpleResizableBoxState extends State<SimpleResizableBox> {
  double width = 200;
  double height = 150;

  void _onDrag(DragUpdateDetails details) {
    setState(() {
      width += details.delta.dx;
      height += details.delta.dy;

      // Clamp values so it doesn’t shrink too small
      width = width.clamp(100, 500);
      height = height.clamp(100, 500);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("width==>${width} | height==>${height}");
    return GestureDetector(
      onTap: () {
        print("width==>${width} | height==>${height}");
      },
      child: Center(
        child: Stack(
          children: [
            Container(
              width: width,
              height: height,
              color: Colors.blue[200],
              alignment: Alignment.center,
              child: const Text("Resizable Box"),
            ),

            // Drag handle (bottom-right corner)
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onPanUpdate: _onDrag,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.drag_handle,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
