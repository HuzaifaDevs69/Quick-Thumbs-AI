import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveConfig {
  static Future<void> initialize() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
  }

  static Future<Box> openThumbnailBox() async {
    return await Hive.openBox('thumbnails'); // A box to store thumbnails
  }

  static void closeBoxes() {
    Hive.close(); // Optional: for cleaning up resources when app is closed
  }
}
