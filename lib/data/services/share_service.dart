import 'dart:io';

import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class ShareService {
  Future<void> shareImage(String url) async {
    try {
      // Save the image locally first
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/thumbnail.png';

      // You would download the image using your existing image downloading logic,
      // here we'll assume you already have the image file on disk.

      final File imageFile = File(filePath);

      // Share the image using share_plus
      await Share.shareXFiles([XFile(imageFile.path)],
          text: 'Check out this awesome YouTube thumbnail!');
    } catch (e) {
      print('Error sharing image: $e');
    }
  }
}
