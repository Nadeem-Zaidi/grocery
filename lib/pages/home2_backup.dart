import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  final GlobalKey _searchBarKey = GlobalKey();
  bool _isSearchBarAtTop = false;
  static const double _headerImageHeight = 400;
  static const double _monsoonBannerHeight = 160.0;
  static const double _searchBarHeight = 45.0;
  static const double _stickyThreshold = kToolbarHeight;
  Color? _dominantColor;
  final String _imageUrl =
      'https://img.freepik.com/premium-vector/monsoon-sale_961071-9377.jpg';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _updatePalette();
  }

  Future<void> _updatePalette() async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(NetworkImage(_imageUrl));
    setState(() {
      _dominantColor = paletteGenerator.dominantColor?.color ?? Colors.blue;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
    _checkSearchBarPosition();
  }

  bool get _shouldStick => (_isSearchBarAtTop && _scrollOffset > 100);

  double get _monsoonBannerOpacity {
    final fadeStart = _headerImageHeight / 4;
    final fadeEnd = _headerImageHeight + 100;
    return 1.0 -
        ((_scrollOffset - fadeStart) / (fadeEnd - fadeStart)).clamp(0.0, 1.0);
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
      offset: _shouldStick ? Offset(0, 0) : Offset(0, -_scrollOffset),
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
          color:
              _shouldStick ? _dominantColor ?? Colors.blue : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_shouldStick)
              Container(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                  Icon(Icons.mic, color: Colors.white),
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
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
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
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(height: _headerImageHeight),
              ),
              SliverToBoxAdapter(
                child: Opacity(
                  opacity: _monsoonBannerOpacity,
                  child: Container(
                    height: _monsoonBannerHeight,
                    color: Colors.blue.shade600,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("ALL YOU NEED FOR THE",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                        Text("Monsoon Season",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(
                    title: Text("Item \${index + 1}"),
                    subtitle: const Text("Sample description"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  childCount: 25,
                ),
              ),
            ],
          ),
          _buildStickyAppBar(),
        ],
      ),
    );
  }
}
