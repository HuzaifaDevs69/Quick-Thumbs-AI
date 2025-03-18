import 'package:flutter/material.dart';
import 'package:yt_thumb_extract/core/constants/app_colors.dart';
import 'package:yt_thumb_extract/presentation/widgets/custom_appbar.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: CustomAppBar(
        titleWidget: Text(
          "About Us",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section with App Name and Tagline
            Center(
              child: Column(
                children: [
                  Text(
                    "QuickThumbs AI",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Download, Edit, and Share Video Thumbnails Instantly! 📸",
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Welcome Section
            _buildSectionTitle("Welcome to QuickThumbs AI!"),
            _buildSectionDescription(
              "The ultimate AI-powered app for grabbing, editing, and sharing high-quality video thumbnails. "
              "Whether you're a content creator, marketer, designer, or just someone in need of a stunning thumbnail, QuickThumbs AI makes it smarter, faster, and more fun! 🌟",
            ),
            SizedBox(height: 20),
            // Key Features Section
            _buildSectionTitle("Key Features"),
            _buildFeatureList([
              "📥 Easy AI-Powered Thumbnail Downloads",
              "🖌️ AI-Enhanced Editing Tools",
              "📤 Share Anywhere",
              "🎨 High-Quality Thumbnails with AI",
              "💡 Perfect for Creators & Marketers",
              "⚡ Fast and AI-Simple",
              "🔒 AI with Privacy",
            ]),
            SizedBox(height: 20),
            // Why Choose Us Section
            _buildSectionTitle("Why Choose QuickThumbs AI?"),
            _buildSectionDescription(
              "🚀 AI Speed & Simplicity: Copy, paste, and download thumbnails smarter and faster!\n"
              "🎯 AI for Everyone: Perfect for creators, marketers, influencers, and designers.\n"
              "🖼️ Smart Thumbnails: AI helps customize and optimize your thumbnails effortlessly.\n"
              "🌍 AI Sharing: Share AI-enhanced thumbnails on any platform.\n"
              "🔒 Privacy First: AI with zero compromise on your data security.",
            ),
            SizedBox(height: 20),
            // How to Use Section
            _buildSectionTitle("How to Use QuickThumbs AI"),
            _buildBulletPointList([
              "Copy the Video Link 📋: Find the video you want to extract the thumbnail from and copy its URL.",
              "Paste the Link in the App 🔗: Open QuickThumbs AI and paste the copied link in the provided space.",
              "Download & Edit with AI 🎨: Instantly download and enhance your thumbnail with our AI tools.",
              "Share Your AI Creation 📤: Share your customized thumbnail on your favorite social platforms or use it in your design work.",
            ]),
            SizedBox(height: 20),
            // Contact Us Section
            _buildSectionTitle("Contact Us"),
            _buildSectionDescription(
              "Have questions? Need support? Reach out to us at:",
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.email, color: AppColors.green),
                SizedBox(width: 8),
                Text(
                  "huzaifadevstack@gmail.com",
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            // Footer Section
            Center(
              child: Text(
                "© 2025 QuickThumbs AI. All Rights Reserved.",
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSectionDescription(String description) {
    return Text(
      description,
      style: TextStyle(
        color: AppColors.grey,
        fontSize: 16,
        height: 1.6,
      ),
    );
  }

  Widget _buildFeatureList(List<String> features) {
    return Column(
      children: features.map((feature) => _buildBulletPoint(feature)).toList(),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPointList(List<String> points) {
    return Column(
      children: points.map((point) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "• ",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Text(
                  point,
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
