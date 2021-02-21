import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ddd_firebase_demo/application/auth/auth_bloc.dart';
import 'package:flutter_ddd_firebase_demo/application/core/injection.dart';
import 'package:flutter_ddd_firebase_demo/presentation/routes/router.gr.dart'
    as app_router;

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => getIt<AuthBloc>()
                  ..add(const AuthEvent.authCheckRequested()))
          ],
          child: MaterialApp(
              title: 'FlutterDddFirebaseCourseDemo',
              debugShowCheckedModeBanner: false,
              builder: ExtendedNavigator.builder(router: app_router.Router()),
              theme: ThemeData.light().copyWith(
                  primaryColor: Colors.green[800],
                  accentColor: Colors.blueAccent,
                  floatingActionButtonTheme: FloatingActionButtonThemeData(
                      backgroundColor: Colors.blue[900]),
                  inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))))));
}
