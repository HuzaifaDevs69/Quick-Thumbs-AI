import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:math';

class EnhancedThumbnailViewer extends StatefulWidget {
  final String? thumbnailUrl;
  final Uint8List? editedImage;
  final Function(BuildContext, String) onImageTap;
  final VoidCallback onMenuTap;

  const EnhancedThumbnailViewer({
    Key? key,
    this.thumbnailUrl,
    this.editedImage,
    required this.onImageTap,
    required this.onMenuTap,
  }) : super(key: key);

  @override
  _EnhancedThumbnailViewerState createState() =>
      _EnhancedThumbnailViewerState();
}

class _EnhancedThumbnailViewerState extends State<EnhancedThumbnailViewer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Thumbnail or Fallback
          widget.thumbnailUrl != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () => widget.onImageTap(
                        context,
                        widget.editedImage != null
                            ? 'edited'
                            : widget.thumbnailUrl!),
                    child: Hero(
                      tag: 'imagePreview',
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: CircularGlowPainter(
                              progress: _controller.value,
                              color: Colors.deepOrangeAccent,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: widget.editedImage != null
                                    ? Image.memory(
                                        widget.editedImage!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        widget.thumbnailUrl!,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Center(
                                            child: Text(
                                              "Failed to load image",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              : const Center(
                  child: Text(
                    "Paste a valid YouTube link\nand preview the thumbnail",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),

          // Overlay Floating Action Button
          // if (widget.thumbnailUrl != null)
          //   Positioned(
          //     right: 20,
          //     top: 200,
          //     child: GestureDetector(
          //       onTap: widget.onMenuTap,
          //       child: Container(
          //         width: 50,
          //         height: 50,
          //         decoration: BoxDecoration(
          //           color: Colors.black.withOpacity(0.5),
          //           borderRadius: BorderRadius.circular(25),
          //           border: Border.all(
          //             color: Colors.deepOrangeAccent,
          //             width: 1.5,
          //           ),
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.deepOrangeAccent.withOpacity(0.6),
          //               blurRadius: 20,
          //               spreadRadius: 2,
          //             ),
          //           ],
          //         ),
          //         child: const Icon(
          //           Icons.more_horiz,
          //           size: 24,
          //           color: Colors.white,
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}

class CircularGlowPainter extends CustomPainter {
  final double progress;
  final Color color;

  CircularGlowPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16.0
      ..shader = SweepGradient(
        colors: [
          Colors.transparent,
          color,
          Colors.transparent,
        ],
        stops: [
          0.0,
          0.5,
          1.0,
        ],
        startAngle: 0.0,
        endAngle: 2 * pi,
        transform: GradientRotation(2 * pi * progress),
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(12.0),
    );

    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
