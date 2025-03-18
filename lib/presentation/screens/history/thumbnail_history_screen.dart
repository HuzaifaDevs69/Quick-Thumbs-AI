import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yt_thumb_extract/core/constants/app_colors.dart';
import 'package:yt_thumb_extract/core/utils/app_logic.dart';
import 'package:yt_thumb_extract/data/models/thumbnail_model.dart';
import 'package:yt_thumb_extract/data/services/controllers/thumbnail_controller.dart';
import 'package:yt_thumb_extract/presentation/widgets/custom_appbar.dart';

class ThumbnailHistory extends StatelessWidget {
  // API URL for fetching thumbnail data
  static const String thumbnailUrl = "YOUR_API_URL";

  // Fetch thumbnails using the API
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          "Thumbnail History",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<ThumbnailModel>(
        future: ThumbnailService.getThumbnails(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show shimmer effect while loading
            return _buildShimmerLoading();
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.result!.isEmpty) {
            return Center(child: Text("No thumbnails available."));
          }

          final thumbnails = snapshot.data!;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: thumbnails.result!.length,
            itemBuilder: (context, index) {
              final thumbnail = thumbnails.result![index];

              return GestureDetector(
                // onTap: () => _showThumbnailOptions(context, thumbnail.imageUrl!),
                child: Stack(
                  children: [
                    Card(
                      elevation: 4,
                      margin: EdgeInsets.all(8),
                      child: Image.network(
                        thumbnail.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: generateRandomColor(),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.download, // Download icon
                            color: Colors.white,
                          ),
                          onPressed: () => _downloadImage(
                            context,
                            thumbnail.imageUrl!,
                            "default", // Default quality
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // This method shows shimmer effect while data is loading
  Widget _buildShimmerLoading() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 6, // Number of shimmer placeholders
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!, // Base shimmer color
          highlightColor: Colors.grey[100]!, // Highlight shimmer color
          period: Duration(
              milliseconds: 1200), // Adjust shimmer speed for shinier effect
          child: Card(
            elevation: 4,
            margin: EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16), // Rounded corners
              child: Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showThumbnailOptions(BuildContext context, ThumbnailModel thumbnail) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.share),
                title: Text('Share Thumbnail'),
                onTap: () {
                  _shareThumbnail(thumbnail);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete Thumbnail'),
                onTap: () {
                  // Add delete functionality if necessary
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _shareThumbnail(ThumbnailModel thumbnail) async {
    final dio = Dio();
    final response = await dio.get(
      thumbnail.result![0].imageUrl!,
      options: Options(responseType: ResponseType.bytes),
    );

    final directory = await getTemporaryDirectory();
    String filePath =
        '${directory.path}/thumbnail_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final file = File(filePath);
    await file.writeAsBytes(response.data);

    await Share.shareXFiles([XFile(filePath)],
        text: 'Check out this thumbnail!');
  }

  Future<void> _downloadImage(
      BuildContext context, String thumbnailUrl, String quality) async {
    try {
      String imageUrl = thumbnailUrl.replaceFirst('maxresdefault', 'hqdefault');

      final dio = Dio();
      final response = await dio.get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      String picturesPath =
          "QuickThumbs-${DateTime.now().millisecondsSinceEpoch}.jpg";
      await File(
              "${(await getApplicationDocumentsDirectory()).path}/$picturesPath")
          .writeAsBytes(response.data);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Image saved as $picturesPath",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.green,
      ));
    } catch (e) {
      _showError(context, "Failed to download image: $e");
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }
}
