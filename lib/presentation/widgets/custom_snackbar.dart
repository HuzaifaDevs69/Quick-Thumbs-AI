import 'package:flutter/material.dart';

class CustomSnackbar {
  static void showSnackbar({
    required BuildContext context,
    required String title,
    required String message,
    required Color bgColor,
    int? duration,
    Widget? icon,
    TextStyle? textStyle, // Custom text style
    Alignment alignment = Alignment.topCenter, // Custom alignment for Snackbar
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top +
            16, // Position below the status bar
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  icon,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: textStyle ??
                            const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ), // Use custom text style or default
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: textStyle ??
                            const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ), // Use custom text style or default
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Insert the overlay
    overlay.insert(overlayEntry);

    // Remove the overlay after the specified duration
    Future.delayed(Duration(seconds: duration ?? 3), () {
      overlayEntry.remove();
    });
  }
}
