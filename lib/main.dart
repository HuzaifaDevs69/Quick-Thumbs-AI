import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yt_thumb_extract/core/constants/app_routes.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:yt_thumb_extract/core/utils/prefs/prefs_config.dart';
import 'package:yt_thumb_extract/presentation/screens/home/home_screen.dart';
import 'package:yt_thumb_extract/presentation/screens/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  await PrefsConfig.init();
  // Register the adapter for ThumbnailModel
  // Hive.registerAdapter(ThumbnailModelAdapter());

  // Perform other initializations if necessary
  SystemSound.play(SystemSoundType.click);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  String _updateMessage = 'Check for updates';

  @override
  void initState() {
    super.initState();
    checkForUpdate();
  }

  Future<void> checkForUpdate() async {
    try {
      final updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.flexibleUpdateAllowed) {
        await InAppUpdate.startFlexibleUpdate();
        setState(() {
          _updateMessage = 'Update started! Please complete the update.';
        });
      } else {
        setState(() {
          _updateMessage = 'No updates available.';
        });
      }
    } on Exception catch (e) {
      setState(() {
        _updateMessage = 'Failed to check for updates: $e';
      });
    }
  }

  Future<void> forceUpdate(BuildContext context) async {
    try {
      final updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.flexibleUpdateAllowed &&
          updateInfo.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No immediate updates available.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } on Exception catch (e) {
      String errorMessage = 'Failed to initiate update: $e';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        initialRoute: '/',
        defaultTransition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 120),
        getPages: AppRoutes.getRoutes(),
        title: 'YT Thumb Extract',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF181818),
          brightness: Brightness.dark,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFFF0000),
            elevation: 0,
            titleTextStyle: TextStyle(color: Colors.white),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Color(0xFFF9F9F9)),
          ),
          fontFamily: 'SF Pro Display',
        ),
        home: PrefsConfig.getIsLoggedIn() ? SplashScreen() : HomeScreen());
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
