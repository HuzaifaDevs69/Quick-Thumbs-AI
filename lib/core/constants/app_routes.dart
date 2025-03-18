import 'package:get/get.dart';
import 'package:yt_thumb_extract/presentation/screens/about/about_screen.dart';
import 'package:yt_thumb_extract/presentation/screens/about/faq_screen.dart';
import 'package:yt_thumb_extract/presentation/screens/auth/login_screen.dart';
import 'package:yt_thumb_extract/presentation/screens/auth/register_screen.dart';
import 'package:yt_thumb_extract/presentation/screens/history/thumbnail_history_screen.dart';
// import 'package:yt_thumb_extract/presentation/screens/history/history_screen.dart';
import 'package:yt_thumb_extract/presentation/screens/home/home_screen.dart';
import 'package:yt_thumb_extract/presentation/screens/splash/splash_screen.dart';

class AppRoutes {
  static List<GetPage<dynamic>> getRoutes() {
    return [
      GetPage(name: '/home', page: () => HomeScreen()),
      GetPage(name: '/register', page: () => RegisterScreen()),
      GetPage(name: '/login', page: () => LoginScreen()),
      GetPage(name: '/about', page: () => AboutUsScreen()),
      GetPage(name: '/history', page: () => ThumbnailHistory()),
      GetPage(name: '/splash', page: () => SplashScreen()),
      GetPage(name: '/faq', page: () => FAQPage()),
    ];
  }
}
