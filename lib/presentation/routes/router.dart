import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter_ddd_firebase_demo/presentation/home/home_screen.dart';
import 'package:flutter_ddd_firebase_demo/presentation/sign_in/sign_in_screen.dart';
import 'package:flutter_ddd_firebase_demo/presentation/splash/splash_screen.dart';

@MaterialAutoRouter(
    generateNavigationHelperExtension: true,
    routes: <AutoRoute>[
      MaterialRoute(page: SplashScreen, initial: true),
      MaterialRoute(page: SignInScreen),
      MaterialRoute(page: HomeScreen)
    ])
class $Router {}
