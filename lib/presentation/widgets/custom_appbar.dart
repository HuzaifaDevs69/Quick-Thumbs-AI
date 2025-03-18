import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? titleWidget;
  final Widget? lead;
  final List<Widget>? actions;
  final Color? color;
  final bool centerTitle; // Add this parameter

  const CustomAppBar({
    super.key,
    this.lead,
    this.actions,
    this.color,
    this.titleWidget,
    this.centerTitle = true, // Default value is true
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: lead,
      actions: actions,
      elevation: 0,
      title: titleWidget,
      centerTitle: false, // Use the dynamic value
      backgroundColor: color, // Optionally use the provided color
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
