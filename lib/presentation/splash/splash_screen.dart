import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ddd_firebase_demo/application/auth/auth_bloc.dart';
import 'package:flutter_ddd_firebase_demo/presentation/routes/router.gr.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          state.map(
              initial: (_) {},
              authenticated: (_) {
                Future.delayed(
                    Duration(seconds: 1),
                    () => ExtendedNavigator.of(context)
                        .replace(Routes.homeScreen));
              },
              unauthenticated: (_) {
                Future.delayed(
                    Duration(seconds: 1),
                    () => ExtendedNavigator.of(context)
                        .replace(Routes.signInScreen));
              });
        },
        child: Scaffold(
            body: Center(child: Image.asset('assets/icon_splash.png'))));
  }
}
