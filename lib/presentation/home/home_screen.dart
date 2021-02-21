import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ddd_firebase_demo/application/auth/auth_bloc.dart';
import 'package:flutter_ddd_firebase_demo/presentation/routes/router.gr.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Image.asset('assets/icon_home.png')));
}
