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

class PageBuilder2 extends StatefulWidget {
  final Widget appBarBackground;
  final Widget stickySectionAppBar;
  final Widget? whenNoListContent;
  final SliverList listSections;
  final Widget? onError;
  const PageBuilder2(
      {super.key,
      required this.appBarBackground,
      required this.stickySectionAppBar,
      required this.whenNoListContent,
      required this.listSections,
      required this.onError});

  @override
  State<PageBuilder2> createState() => _PageBuilderState();
}

class _PageBuilderState extends State<PageBuilder2> {
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
              widget.appBarBackground,
              SliverToBoxAdapter(child: widget.whenNoListContent),
              widget.listSections,
            ],
          ),
          widget.stickySectionAppBar
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
