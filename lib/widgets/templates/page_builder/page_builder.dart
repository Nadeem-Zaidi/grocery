import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/section/dashboard_bloc/dashboard_bloc.dart';
import 'package:grocery_app/database_service.dart/dashboard/section.dart'
    as db_section;
import 'package:grocery_app/utils/screen_utils.dart';
import 'package:grocery_app/widgets/templates/page_builder/page_builder_bottom_navigator.dart';
import 'package:grocery_app/widgets/templates/page_builder/page_builder_topsection.dart';
import 'package:grocery_app/widgets/templates/section_builder.dart';
import 'package:grocery_app/widgets/utilities_widget/dialog_box/dialog_box_item.dart';
import '../../cards/promo_cards.dart';
import '../../utilities_widget/dialog_box/dialogbox_for_template_selection.dart';
import 'section_types.dart';

class PageBuilder extends StatefulWidget {
  const PageBuilder({super.key});

  @override
  State<PageBuilder> createState() => _PageBuilderState();
}

class _PageBuilderState extends State<PageBuilder> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  final GlobalKey _searchBarKey = GlobalKey();
  final GlobalKey _appBarKey = GlobalKey();
  final GlobalKey _appbarListSection = GlobalKey();
  bool _changeColorNormal = false;
  bool _isSearchBarAtTop = false;
  // static const double _headerImageheight = 600;
  static const double _searchbarheight = 45.0;
  bool get _shouldStick => (_isSearchBarAtTop && _scrollOffset > 100);

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
    }
  }

  void _handleScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
    _checkSearchBarPosition();
    _checkPromoSectionPosition();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<DashboardBloc>(context);
    double screenWidth = ScreenUtils.getScreenWidth(context);
    double screenHeight = ScreenUtils.getScreenHeight(context);

    List<db_section.Section> promoSection =
        bloc.state.page.promoBanner.values.toList();
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  key: _appBarKey,
                  height: bloc.state.page.appbarHeight,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      BlocBuilder<DashboardBloc, DashboardState>(
                          builder: (context, state) {
                        if (state.page.appBarImage != null) {
                          return Container(
                            height: 400,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(File(bloc.state.page
                                    .appBarImage!.path)), // local image
                                fit: BoxFit.cover, // cover, contain, fill, etc.
                              ),
                            ),
                          );
                        } else if (state.page.appBarImageUrl != null) {
                          return SizedBox(
                            height: 400,
                            width: double.infinity,
                            child: Image.network(
                              state.page.appBarImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.image_not_supported_outlined,
                                size: 40,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.5),
                              ),
                            ),
                          );
                        }

                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.white, Colors.white],
                              begin: Alignment.topCenter, // start at the top
                              end: Alignment.bottomCenter, //
                            ),
                          ),
                        );
                      }),
                      BlocBuilder<DashboardBloc, DashboardState>(
                        builder: (context, state) {
                          if (state.page.promoBanner.isEmpty) {
                            return SizedBox.shrink();
                          }
                          return Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Stack(
                              children: [
                                sectionBuilder(
                                    section: bloc.state.page.promoBanner.values
                                        .toList()[0]),
                                Positioned(
                                  right: 0,
                                  top: 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      context.read<DashboardBloc>().add(
                                          RemoveSection(
                                              id: bloc
                                                  .state.page.promoBanner.keys
                                                  .toList()[0]));
                                    },
                                    child: Icon(Icons.cancel),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  final sections = state.page.sections.values.toList();

                  if (sections.isEmpty) {
                    // Reset scroll offset
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollController.jumpTo(0);
                    });
                  }
                  if (state.page.sections.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Container(
                        height: 400,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              "No sections yet",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Stack(
                          children: [
                            sectionBuilder(section: sections[index]),
                            Positioned(
                              top: 10,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  context.read<DashboardBloc>().add(
                                        RemoveSection(id: sections[index].id!),
                                      );
                                },
                                child: Icon(
                                  Icons.cancel,
                                  color: Colors.red.shade400,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      childCount: sections.length,
                    ),
                  );
                },
              )
            ],
          ),
          BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              return StickyAppBar<DashboardState>(
                searchBarKey: _searchBarKey,
                searchbarHeight: _searchbarheight,
                scrollOffset: _scrollOffset,
                shouldStick: _shouldStick,
                state: bloc.state,
                appbarListSectionKey: _appbarListSection,
                changeAppBarColor: _changeColorNormal,
              );
            },
          ),
          Positioned(
            right: 0,
            top: 20,
            child: IconButton(
                onPressed: () {
                  context
                      .read<DashboardBloc>()
                      .add(SetAppbarHeight(value: 700));
                },
                icon: Icon(Icons.edit)),
          ),
        ],
      ),
      bottomNavigationBar: PageBuilderBottomNavigatorBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
