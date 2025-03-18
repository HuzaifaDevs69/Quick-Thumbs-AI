import 'package:flutter/material.dart';
import 'package:yt_thumb_extract/core/constants/app_colors.dart';

class FAQPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      "question": "What is QuickThumbs AI?",
      "answer":
          "QuickThumbs AI is an AI-powered app that helps you download, edit, and share high-quality video thumbnails instantly. It's perfect for content creators, marketers, designers, and anyone in need of stunning thumbnails."
    },
    {
      "question": "How do I download a thumbnail?",
      "answer":
          "Simply copy the video link, paste it into the app, and QuickThumbs AI will fetch the thumbnail instantly. It's that simple!"
    },
    {
      "question": "Can I customize thumbnails using QuickThumbs AI?",
      "answer":
          "Yes! Use our AI-enhanced editing tools to add text, stickers, crop, adjust colors, and even apply AI-suggested enhancements."
    },
    {
      "question": "Is my data secure with QuickThumbs AI?",
      "answer":
          "Absolutely. Your privacy is our top priority. We don't collect or store any personal information while you use the app."
    },
    {
      "question": "Can I share thumbnails directly from the app?",
      "answer":
          "Yes! QuickThumbs AI optimizes thumbnails for social platforms like YouTube, Instagram, Facebook, and Twitter, making sharing effortless."
    },
    {
      "question": "What platforms does QuickThumbs AI support?",
      "answer":
          "QuickThumbs AI supports thumbnails from platforms like YouTube, Vimeo, and more, ensuring you always get high-quality results."
    },
    {
      "question": "Is QuickThumbs AI free to use?",
      "answer":
          "QuickThumbs AI offers a free version with basic features. For advanced editing tools and unlimited downloads, you can explore our premium plans."
    },
    {
      "question": "Who can benefit from QuickThumbs AI?",
      "answer":
          "Content creators, marketers, social media influencers, and designers can all boost their productivity with QuickThumbs AI."
    },
    {
      "question": "How do I contact support?",
      "answer":
          "For support, reach out to us at huzaifadevstack@gmail.com. We're here to help!"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        title: Text(
          'FAQs',
          style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        backgroundColor: AppColors.primary,
        elevation: 4,
        iconTheme: IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            final faq = faqs[index];
            return _buildStylishFAQItem(faq['question']!, faq['answer']!);
          },
        ),
      ),
    );
  }

  Widget _buildStylishFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.textfieldFilledColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            collapsedIconColor: AppColors.white,
            iconColor: AppColors.primary,
            tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              question,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  answer,
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
