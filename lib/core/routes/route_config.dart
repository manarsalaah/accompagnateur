import 'package:flutter/material.dart';
import 'package:accompagnateur/features/login/presentation/screen/login_screen.dart';
import '../presentation/screens/main_screen.dart';
import '../presentation/screens/quick_access_screen.dart';
import '../presentation/screens/splash_screen.dart';
import 'app_routes.dart';

Map<String, WidgetBuilder> getRoutes() {
  return {
    AppRoutes.splashScreen: (context) => SplashScreen(),
    AppRoutes.mainScreen: (context) => MainScreen(),
    AppRoutes.loginScreen: (context) => const LoginScreen(),
    AppRoutes.quickAccessScreen: (context) => const QuickAccessScreen(),
  };
}
