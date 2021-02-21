import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ddd_firebase_demo/application/sign_in_form/sign_in_form_bloc.dart';
import 'package:flutter_ddd_firebase_demo/application/core/injection.dart';
import 'package:flutter_ddd_firebase_demo/presentation/sign_in/widgets/sign_in_form.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      resizeToAvoidBottomPadding: false,
      body: BlocProvider(
          create: (context) => getIt<SignInFormBloc>(), child: SignInForm()));
}
