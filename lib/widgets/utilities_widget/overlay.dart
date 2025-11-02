import 'package:flutter/material.dart';

class OverlayHelper {
  static OverlayEntry? _currentOverlayEntry;

  static void showOverlay(BuildContext context, String text) {
    // Ensure any previous overlay is removed
    if (_currentOverlayEntry != null) {
      _currentOverlayEntry!.remove();
      _currentOverlayEntry = null;
    }

    _currentOverlayEntry = OverlayEntry(
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Container(
            width: 200,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  width: 10,
                ),
                Material(
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Find the overlay in the widget tree and insert the overlay entry.
    Overlay.of(context).insert(_currentOverlayEntry!);
  }

  static void removeOverlay() {
    if (_currentOverlayEntry != null) {
      _currentOverlayEntry!.remove();
      _currentOverlayEntry = null;
    }
  }
}
