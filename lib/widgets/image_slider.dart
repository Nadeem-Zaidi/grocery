import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  final List<String> imageUrls;
  const ImageSlider({super.key, required this.imageUrls});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late PageController _pageController;
  int activePage = 0;
  bool _isAdjusting = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.imageUrls.length);
    activePage = widget.imageUrls.length;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> images = widget.imageUrls;

    return Column(
      children: [
        SizedBox(
          height: 350,
          child: NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              if (_isAdjusting) return true;

              if (activePage == 0) {
                _isAdjusting = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _pageController.jumpToPage(images.length);
                  setState(() {
                    activePage = images.length;
                  });
                  _isAdjusting = false;
                });
              } else if (activePage == images.length * 2 - 1) {
                _isAdjusting = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _pageController.jumpToPage(images.length - 1);
                  setState(() {
                    activePage = images.length - 1;
                  });
                  _isAdjusting = false;
                });
              }
              return true;
            },
            child: PageView.builder(
              itemCount: images.length * 2,
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  activePage = page;
                });
              },
              itemBuilder: (context, pagePosition) {
                final actualIndex = pagePosition % images.length;
                return Container(
                  margin: const EdgeInsets.all(10),
                  child: Image.network(
                    width: double.infinity,
                    images[actualIndex],
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              indicator(images.length, activePage % images.length, context),
        ),
      ],
    );
  }
}

List<Widget> indicator(
    int imagesLength, int currentIndex, BuildContext context) {
  return List<Widget>.generate(imagesLength, (index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: currentIndex == index
            ? Theme.of(context).primaryColor
            : Theme.of(context).primaryColor.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
    );
  });
}
