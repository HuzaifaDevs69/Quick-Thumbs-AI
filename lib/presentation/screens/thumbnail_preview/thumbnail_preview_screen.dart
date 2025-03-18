import 'dart:typed_data';

import 'package:flutter/material.dart';

class FullscreenImagePreview extends StatelessWidget {
  final dynamic imageSource;

  const FullscreenImagePreview({Key? key, required this.imageSource})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: 'imagePreview',
              child: imageSource is Uint8List
                  ? Image.memory(
                      imageSource,
                      fit: BoxFit.contain,
                    )
                  : Image.network(
                      imageSource,
                      fit: BoxFit.contain,
                    ),
            ),
          ),
          // Close Button
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.7),
                ),
                padding: const EdgeInsets.all(8.0),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
