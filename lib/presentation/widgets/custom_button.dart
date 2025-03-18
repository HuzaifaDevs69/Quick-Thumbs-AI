import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yt_thumb_extract/core/constants/app_colors.dart';

class YoutubeButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed; // Nullable to handle disabled state
  final bool disabled; // New parameter for disabling the button

  const YoutubeButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.disabled = false, // Default is false (enabled)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: disabled
              ? AppColors.disabledColor
              : AppColors.primary, // Change color when disabled
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: disabled ? 0 : 3, // Remove elevation when disabled
        ),
        onPressed: disabled ? null : onPressed, // Disable button interaction
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (disabled)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3, // Thickness of progress indicator
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else ...[
              if (icon != null) ...[
                Icon(icon, color: Colors.white),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
