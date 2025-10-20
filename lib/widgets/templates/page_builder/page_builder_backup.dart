import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/blocs/section/dashboard_bloc/dashboard_bloc.dart';
import 'package:grocery_app/database_service.dart/dashboard/section.dart'
    as db_section;
import 'package:grocery_app/utils/screen_utils.dart';
import 'package:grocery_app/widgets/templates/page_builder/page_builder_bottom_navigator.dart';
import 'package:grocery_app/widgets/templates/page_builder/page_builder_topsection.dart';
import 'package:grocery_app/widgets/templates/page_builder/wrapper/dashboard_appbar_background_builder.dart';
import 'package:grocery_app/widgets/templates/section_builder.dart';

class PageBuilder extends StatefulWidget {
  final Function appBarBuilder;
  const PageBuilder({super.key, required this.appBarBuilder});

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
                child: BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    return AppBarBackgroundBuilder(
                        onHeightIncreement: () =>
                            context.read<DashboardBloc>().add(
                                  SetAppbarHeight(
                                    value: context
                                            .read<DashboardBloc>()
                                            .state
                                            .page
                                            .appbarHeight +
                                        10,
                                  ),
                                ),
                        onHeightDecreement: () =>
                            context.read<DashboardBloc>().add(
                                  SetAppbarHeight(
                                    value: context
                                            .read<DashboardBloc>()
                                            .state
                                            .page
                                            .appbarHeight -
                                        10,
                                  ),
                                ),
                        backGroundBuilder:
                            BlocBuilder<DashboardBloc, DashboardState>(
                                buildWhen: (previous, current) =>
                                    ((previous.page.appBarImage !=
                                            current.page.appBarImage) ||
                                        previous.page.appBarImageUrl !=
                                            current.page.appBarImageUrl),
                                builder: (context, state) {
                                  if (state.page.appBarImage != null) {
                                    return Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: FileImage(File(bloc
                                              .state
                                              .page
                                              .appBarImage!
                                              .path)), // local image
                                          fit: BoxFit
                                              .cover, // cover, contain, fill, etc.
                                        ),
                                      ),
                                    );
                                  } else if (state.page.appBarImageUrl !=
                                      null) {
                                    return SizedBox(
                                      width: double.infinity,
                                      child: Image.network(
                                        state.page.appBarImageUrl!,
                                        fit: BoxFit.fill,
                                        errorBuilder: (_, __, ___) => Icon(
                                          Icons.image_not_supported_outlined,
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
                                        colors: [
                                          Colors.blue,
                                          Colors.white,
                                          Colors.white
                                        ],
                                        begin: Alignment
                                            .topCenter, // start at the top
                                        end: Alignment.bottomCenter, //
                                      ),
                                    ),
                                  );
                                }),
                        promoBannerBuilder:
                            BlocBuilder<DashboardBloc, DashboardState>(
                          builder: (context, state) {
                            if (state.page.promoBanner.isEmpty) {
                              return SizedBox.shrink();
                            }
                            if (state.promoBannerVerticalPosition > 0) {}
                            return Positioned(
                              left: 0,
                              right: 0,
                              top: screenHeight *
                                  (state.promoBannerVerticalPosition / 100),
                              child: Stack(
                                children: [
                                  sectionBuilder(
                                      section: bloc
                                          .state.page.promoBanner.values
                                          .toList()[0]),
                                  Positioned(
                                    right: 0,
                                    top: 0,
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
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 70,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              context.read<DashboardBloc>().add(
                                                  SetPromoSectionPosition(
                                                      fromTop: -5));
                                            },
                                            child: Icon(Icons.move_up)),
                                        GestureDetector(
                                            onTap: () {
                                              context.read<DashboardBloc>().add(
                                                  SetPromoSectionPosition(
                                                      fromTop: 5));
                                            },
                                            child: Icon(Icons.move_down))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        dynamicHeight: bloc.state.page.appbarHeight / 100);
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -200), // move 20px right and 10px up
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.blue,
                    child: const Center(child: Text("Shifted")),
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
                      child: SizedBox(
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
          StickyAppBar<DashboardState>(
            searchBarKey: _searchBarKey,
            searchbarHeight: _searchbarheight,
            scrollOffset: _scrollOffset,
            shouldStick: _shouldStick,
            state: bloc.state,
            appbarListSectionKey: _appbarListSection,
            changeAppBarColor: _changeColorNormal,
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
