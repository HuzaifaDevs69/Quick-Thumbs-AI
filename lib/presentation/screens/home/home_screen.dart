import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:confetti/confetti.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yt_thumb_extract/core/constants/app_colors.dart';
import 'package:yt_thumb_extract/core/utils/permission_config.dart';
import 'package:yt_thumb_extract/data/models/thumbnail_model.dart';
import 'package:yt_thumb_extract/data/services/controllers/image_generation_controller.dart';
import 'package:yt_thumb_extract/data/services/controllers/thumbnail_controller.dart';
import 'package:yt_thumb_extract/data/services/image_service.dart';
import 'package:yt_thumb_extract/presentation/screens/thumbnail_preview/thumbnail_preview_screen.dart';
import 'package:yt_thumb_extract/presentation/widgets/custom_drawer.dart';
import 'package:yt_thumb_extract/presentation/widgets/custom_snackbar.dart';
import 'package:yt_thumb_extract/presentation/widgets/custom_text_field.dart';
import 'package:yt_thumb_extract/presentation/widgets/thumbnail_container.dart'; // For image editing

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? thumbnailUrl; // Original or Edited image
  String? enhancedThumbnailUrl;
  final ConfettiController _confettiController = ConfettiController();
  TextEditingController urlController = TextEditingController();

  // Variables to store the original and edited images
  Uint8List? originalImage;
  Uint8List? editedImage;
  String? imageResolution;
  String? fileSize;
  late ThumbnailModel _thumbnail;

  @override
  void initState() {
    super.initState();
    _confettiController.stop();
    PermissionChecker().requestPermissions();

    // getStoragePermission();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    urlController.dispose();

    super.dispose();
  }

  void _updateThumbnail(String url) {
    try {
      final uri = Uri.parse(url);
      String? videoId;

      if (uri.host.contains("youtube.com")) {
        videoId = uri.queryParameters['v'];
      } else if (uri.host.contains("youtu.be")) {
        videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
      }

      if (videoId != null) {
        setState(() {
          thumbnailUrl =
              'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
        });
        _triggerConfetti();
        _fetchImageDetails(thumbnailUrl!); // Fetch image details
        FocusScope.of(context).unfocus();
      } else {
        setState(() {
          thumbnailUrl = null;
        });
        _showError("Invalid YouTube link.");
      }
    } catch (e) {
      setState(() {
        thumbnailUrl = null;
      });
      _showError("An error occurred. Please check your URL.");
    }
  }

  void _triggerConfetti() {
    debugPrint(
        "🎉✨ Confetti has been unleashed! 🎊🎆 Get ready for the celebration! 🚀🥳");

    _confettiController.play();
    Future.delayed(const Duration(seconds: 2), () {
      _confettiController.stop();
    });
  }

  void _showError(String message) {
    CustomSnackbar.showSnackbar(
      context: context,
      title: "Error",
      message: message,
      bgColor: AppColors.error,
    );
    // print
    debugPrint("🚨 Error: $message");
  }

  // Fetch image details like resolution and size
  void _fetchImageDetails(String url) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      final imageBytes = response.data;
      final image = await decodeImageFromList(imageBytes);
      final resolution = '${image.width}x${image.height}';
      final sizeInBytes = imageBytes.lengthInBytes;
      final sizeInKB = (sizeInBytes / 1024).toStringAsFixed(2);

      setState(() {
        imageResolution = resolution;
        fileSize = '$sizeInKB KB';
      });

      // Store the thumbnail to Hive
      _saveThumbnailToHive(imageBytes, url, resolution, '$sizeInKB KB');
    } catch (e) {
      setState(() {
        imageResolution = 'Unknown';
        fileSize = 'Unknown';
      });
      _showError("Failed to fetch image details: $e");
    }
  }

  // Future<void> _downloadImage() async {
  //   if (thumbnailUrl == null) {
  //     _showError("No image to download!");
  //     return;
  //   }

  //   try {
  //     final dio = Dio();
  //     final response = await dio.get(
  //       thumbnailUrl!,
  //       options: Options(responseType: ResponseType.bytes),
  //     );

  //     // Get the path to external storage (root directory)
  //     String externalStoragePath =
  //         '/storage/emulated/0'; // For most Android devices
  //     Directory quickThumbsDirectory =
  //         Directory('$externalStoragePath/QuickThumbs');

  //     // Create 'QuickThumbs' directory if it doesn't exist
  //     if (!await quickThumbsDirectory.exists()) {
  //       await quickThumbsDirectory.create(recursive: true);
  //     }

  //     // Generate a random file name
  //     String randomFileName =
  //         'youtube_thumbnail_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}.jpg';

  //     // Define the file path in the 'QuickThumbs' directory
  //     final filePath = '${quickThumbsDirectory.path}/$randomFileName';
  //     final file = File(filePath);

  //     // Save the image to the file
  //     await file.writeAsBytes(response.data);

  //     CustomSnackbar.showSnackbar(
  //         // context: context,
  //         title: "Download Successful 🎉",
  //         message: "Image saved to Gallery",
  //         bgColor: AppColors.green,
  //         context: context);
  //   } catch (e) {
  //     _showError("Failed to download image: $e");
  //   }
  // }

  String lastFileName = '';
  Future<void> _downloadImage(String quality) async {
    if (thumbnailUrl == null) {
      _showError("No image to download!");
      return;
    }

    try {
      // Determine the image URL based on quality
      String imageUrl;
      switch (quality) {
        case '1080':
          imageUrl = thumbnailUrl!.replaceFirst('maxresdefault', 'hqdefault');
          break;
        case '720':
          imageUrl = thumbnailUrl!.replaceFirst('maxresdefault', 'mqdefault');
          break;
        case '480':
          imageUrl = thumbnailUrl!.replaceFirst('maxresdefault', 'sddefault');
          break;
        case '360':
          imageUrl = thumbnailUrl!.replaceFirst('maxresdefault', 'default');
          break;
        default:
          imageUrl = thumbnailUrl!; // Default image resolution
      }

      final dio = Dio();
      final response = await dio.get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // Now, save the image using SaverGallery
      String picturesPath =
          "QuickThumbs-${DateTime.now().millisecondsSinceEpoch}.jpg";
      final result = await SaverGallery.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
        fileName: picturesPath,
        androidRelativePath: "Pictures/QuickThumbs",
        skipIfExists: true,
      );

      // Assuming result is a boolean (true/false)
      if (result.isSuccess == true) {
        CustomSnackbar.showSnackbar(
          context: context,
          title: "Download Successful 🎉",
          message: "Image saved to Gallery in QuickThumbs/$picturesPath",
          bgColor: AppColors.green,
        );
      } else {
        _showError("Failed to save the image.");
      }
    } catch (e) {
      _showError("Failed to download image: $e");
    }
  }

  void _chooseQty() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text(
            "Choose an Quality",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // message: const Text("Choose an Quality"),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _downloadImage('default'); // Download the default image
                // _getHttp();
              },
              child: const Text("Download Original Image"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _downloadImage('1080'); // Download in 1080p
              },
              child: const Text("Download 1080p Image"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _downloadImage('720'); // Download in 720p
              },
              child: const Text("Download 720p Image"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _downloadImage('480'); // Download in 480p
              },
              child: const Text("Download 480p Image"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _downloadImage('360'); // Download in 360p
              },
              child: const Text("Download 360p Image"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _downloadImage('240'); // Download in 360p
              },
              child: const Text("Download 240p Image"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _downloadImage('144'); // Download in 360p
              },
              child: const Text("Download 144p Image"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _editImage();
              },
              child: const Text("Edit Image"),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            isDefaultAction: true,
            child: const Text("Cancel"),
          ),
        );
      },
    );
  }

  bool permissionGranted = false;
  Future<void> getStoragePermission() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;

    if (android.version.sdkInt < 33) {
      if (await Permission.storage.request().isGranted) {
        setState(() {
          permissionGranted = true;
        });
      } else if (await Permission.storage.request().isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.storage.request().isDenied) {
        setState(() {
          permissionGranted = false;
        });
      }
    } else {
      // If SDK version >= 33, consider handling other permissions (like media) here.
      setState(() {
        permissionGranted = true;
      });
    }
  }

  void _showImagePreviewWithAnimation(
      BuildContext context, dynamic imageSource) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: FullscreenImagePreview(imageSource: imageSource),
          );
        },
      ),
    );
  }

  Future<void> shareImage(
      String thumbnailUrl, String quality, BuildContext context) async {
    if (thumbnailUrl.isEmpty) {
      _showError("No image to share!");
      return;
    }

    try {
      String imageUrl;
      switch (quality) {
        case '1080':
          imageUrl = thumbnailUrl.replaceFirst('maxresdefault', 'hqdefault');
          break;
        case '720':
          imageUrl = thumbnailUrl.replaceFirst('maxresdefault', 'mqdefault');
          break;
        case '480':
          imageUrl = thumbnailUrl.replaceFirst('maxresdefault', 'sddefault');
          break;
        case '360':
          imageUrl = thumbnailUrl.replaceFirst('maxresdefault', 'default');
          break;
        default:
          imageUrl = thumbnailUrl; // Default image resolution
      }

      final dio = Dio();
      final response = await dio.get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // Get the path to temporary directory
      final directory = await getTemporaryDirectory();
      String filePath =
          '${directory.path}/thumbnail_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Save the image to the file
      final file = File(filePath);
      await file.writeAsBytes(response.data);

      // Share the image using share_plus
      await Share.shareXFiles([XFile(filePath)],
          text:
              '✨ Check out this awesome YouTube thumbnail I found! 📸\nPerfect for your next video or project! 🚀');

      // Show success snackbar
      CustomSnackbar.showSnackbar(
        context: context,
        title: "Share Successful 🎉",
        message: "Image shared to other apps",
        bgColor: AppColors.green,
      );
    } catch (e) {
      _showError("Failed to share image: $e");
    }
  }

  void _openMenu() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          // title: const Text(
          //   "",
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
          // message: const Text(""),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                enhanceThumbnail();
              },
              child: const Text(
                "🚀 Enhanced Thumbnail ✨",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _chooseQty();
              },
              child: const Text(
                "📥 Download Image",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                shareImage(thumbnailUrl!, 'default', context);
              },
              child: const Text(
                "📤 Share Image",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _editImage();
              },
              child: const Text(
                "✏️ Edit Image",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _resetImage();
              },
              child: const Text(
                "🔄 Reset Image",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            isDefaultAction: true,
            child: const Text("Cancel"),
          ),
        );
      },
    );
  }

  void _saveThumbnailToHive(
      Uint8List imageBytes, String url, String resolution, String size) async {
    ThumbnailService.createThumbnail(1, url, url, context);
  }

  Future<void> _editImage() async {
    if (thumbnailUrl == null) {
      _showError("No image to edit!");
      return;
    }

    try {
      final dio = Dio();
      final response = await dio.get(
        thumbnailUrl!,
        options: Options(responseType: ResponseType.bytes),
      );

      // Store the original image
      setState(() {
        originalImage = response.data;
        editedImage = originalImage;
      });

      // Pass the image data to the editor
      final editedImageData = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditor(
            image: response.data,
          ),
        ),
      );

      if (editedImageData != null) {
        setState(() {
          editedImage = editedImageData;
        });
        CustomSnackbar.showSnackbar(
            // context: context,
            title: "Image Edited 🎨",
            message: "Changes saved successfully",
            bgColor: AppColors.green,
            context: context);
      }
    } catch (e) {
      _showError("Failed to edit image: $e");
    }
  }

  void _resetImage() {
    setState(() {
      editedImage = originalImage; // Reset to the original image
    });
    CustomSnackbar.showSnackbar(
        // context: context,
        title: "Reset Successful 🎉",
        message: "Image reset successfully",
        bgColor: AppColors.green,
        context: context);
  }

  void enhanceThumbnail() async {
    final response = await ImageGenerateController.textToImage(
        prompt: "", imageUrl: thumbnailUrl!, context: context);

    setState(() {
      enhancedThumbnailUrl = response['images'][0]['url'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        drawer: AppDrawer(),
        floatingActionButton: thumbnailUrl != null
            ? FloatingActionButton(
                onPressed: () {
                  _openMenu();
                },
                child: customAssetPath(
                    imagePath: ImageConfig.menuIcon,
                    size: 24,
                    color: Colors.white),
                backgroundColor: AppColors.primary,
              )
            : null,
        backgroundColor: AppColors.scaffoldColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary,
          title: InkWell(
              onTap: () {
                PermissionChecker.checkPermission(context);
              },
              child: const Text("Copy-Paste your YouTube URL here")),
        ),
        body: Column(
          children: [
            // Search Bar
            // Container(
            //   margin: const EdgeInsets.only(bottom: 16.0),
            //   padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            //   color: AppColors.primary,
            //   child: Form(
            //     child: TextFormField(
            //       autofocus: true,
            //       textInputAction: TextInputAction.done,
            //       controller: urlController,
            //       onChanged: _updateThumbnail,
            //       onFieldSubmitted: _updateThumbnail,
            //       style: const TextStyle(color: Colors.black),
            //       decoration: InputDecoration(
            //         fillColor: Colors.white,
            //         prefixIcon: Icon(
            //           Icons.search,
            //           color: AppColors.accent.withOpacity(0.64),
            //         ),
            //         suffixIcon: IconButton(
            //           icon: Icon(Icons.paste, color: AppColors.accent),
            //           onPressed: () async {
            //             ClipboardData? clipboardData =
            //                 await Clipboard.getData('text/plain');
            //             if (clipboardData != null && clipboardData.text != null) {
            //               _updateThumbnail(clipboardData.text!);
            //               setState(() {
            //                 urlController.text = clipboardData.text!;
            //               });
            //             }
            //           },
            //         ),
            //         hintText: "Paste Link Here......",
            //         filled: true,
            //         contentPadding: const EdgeInsets.symmetric(
            //             horizontal: 16.0 * 1.5, vertical: 16.0),
            //         border: const OutlineInputBorder(
            //           borderSide: BorderSide.none,
            //           borderRadius: BorderRadius.all(Radius.circular(50)),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 16),
            CustomTextField(
              urlController: urlController,
              onChange: _updateThumbnail,
              onPress: () async {
                ClipboardData? clipboardData =
                    await Clipboard.getData('text/plain');
                if (clipboardData != null && clipboardData.text != null) {
                  _updateThumbnail(clipboardData.text!);
                  setState(() {
                    urlController.text = clipboardData.text!;
                  });
                  FocusScope.of(context).unfocus();
                }
              },
            ),
            // Display Thumbnail and Image Details
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                particleDrag: 0.05, // Slight slowdown for realism
                emissionFrequency: 0.05,
                numberOfParticles: 30,
                gravity: 0.1,
                shouldLoop: false,
              ),
            ),

            EnhancedThumbnailViewer(
              thumbnailUrl: enhancedThumbnailUrl ?? thumbnailUrl,
              editedImage: editedImage,
              onImageTap: (context, url) {
                _showImagePreviewWithAnimation(context, url);
              },
              onMenuTap: () {
                _openMenu();
              },
            ),

//!             // Image Details
            // if (thumbnailUrl != null)
            //   Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.stretch,
            //       children: [
            //         ListTile(
            //           leading: const Icon(Icons.info_outline),
            //           title: Text("Resolution: $imageResolution"),
            //           subtitle: Text("File Size: $fileSize"),
            //         ),
            //         if (editedImage != null)
            //           TextButton(
            //             onPressed: _resetImage,
            //             child: Text("Reset to Original"),
            //           ),
            //       ],
            //     ),
            //   ),
            // Shimmer.fromColors(
            //   baseColor: AppColors.primary,
            //   highlightColor: AppColors.accent,
            //   child: const Text(
            //     "YouTube Thumbnail Downloader",
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //       fontSize: 20,
            //     ),
            //   ),
            // ),
            if (lastFileName != "")
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Note:\n1).Open File Manager\n2).Go to QuickThumbs\n3).Find $lastFileName",
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
          ],
        ),
      ),
    );
  }
}
