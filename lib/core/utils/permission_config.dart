import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionChecker {
  static Future<void> checkPermission(BuildContext context) async {
    // Build permission list dynamically
    List<Permission> permissions = [Permission.camera, Permission.storage];

    // Request all required permissions
    Map<Permission, PermissionStatus> statuses = await permissions.request();

    // Check if all permissions are granted
    bool isGranted = statuses.values.every((status) =>
        status == PermissionStatus.granted ||
        status == PermissionStatus.limited);

    if (isGranted) {
      print("All permissions granted.");
      return;
    }

    // Check for permanently denied or denied permissions
    bool isPermanentlyDenied = statuses.values
        .any((status) => status == PermissionStatus.permanentlyDenied);

    if (isPermanentlyDenied) {
      _showPermissionDeniedDialog(context);
    } else {
      _showPermissionGuide(context);
    }
  }

  static Future<int> _getAndroidVersion() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt; // This returns the numeric SDK version
  }

  static void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text(
              'Some permissions are permanently denied. Please enable them manually in app settings.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Go to settings'),
              onPressed: () {
                openAppSettings(); // Opens app settings
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void _showPermissionGuide(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
            'Some permissions are denied. Please allow them in app settings.'),
        action: SnackBarAction(
          label: 'Go to settings',
          onPressed: () {
            openAppSettings(); // Opens app settings
          },
        ),
      ),
    );
  }

  Future<void> requestPermissions() async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;
    final storageStatus = android.version.sdkInt < 33
        ? await Permission.storage.request()
        : await Permission.manageExternalStorage.request();
    if (storageStatus == PermissionStatus.granted) {
      print("granted");
    }
    if (storageStatus == PermissionStatus.denied) {
      print("denied");
    }
    if (storageStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }
}
