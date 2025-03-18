import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yt_thumb_extract/core/constants/app_colors.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.scaffoldColor, // Set drawer background color
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Container(
            padding: EdgeInsets.only(top: 50, left: 20, bottom: 20),
            color: AppColors.primary,
            child: Row(
              children: [
                // CircleAvatar(
                //   radius: 30,
                //   backgroundColor: AppColors.white,
                //   child: Icon(
                //     Icons.person,
                //     color: AppColors.primary,
                //     size: 30,
                //   ),
                // ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome!",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Text(
                    //   "User Name",
                    //   style: TextStyle(
                    //     color: AppColors.white,
                    //     fontSize: 14,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          // Drawer items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.home,
                  label: 'Home',
                  onTap: () {
                    // Navigate to home
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.image_search,
                  label: 'Thumbnail History',
                  onTap: () {
                    Get.toNamed('/history');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.settings,
                  label: 'Settings',
                  onTap: () {
                    // Navigate to settings
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.info_outline,
                  label: 'About',
                  onTap: () {
                    Get.toNamed('/about');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.question_answer,
                  label: 'FAQ',
                  onTap: () {
                    Get.toNamed('/faq');
                  },
                ),
                Divider(
                  color: AppColors.grey,
                ),
                _buildDrawerItem(
                  icon: Icons.logout,
                  label: 'Logout',
                  onTap: () {
                    // Handle logout
                  },
                  color: AppColors.error,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? AppColors.white,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: AppColors.white,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}
