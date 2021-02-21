import 'package:auto_route/auto_route.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ddd_firebase_demo/application/sign_in_form/sign_in_form_bloc.dart';
import 'package:flutter_ddd_firebase_demo/presentation/routes/router.gr.dart';

class SignInForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
        listener: (context, state) {
          state.authFailureOrSuccessOption.fold(
              () {},
              (either) => either.fold((failure) {
                    FlushbarHelper.createError(
                      message: failure.map(
                        cancelledByUser: (_) => 'Cancelled',
                        serverError: (_) => '信箱或密碼錯誤',
                        emailAlreadyInUse: (_) => 'Email already in use',
                        invalidEmailAndPasswordCombination: (_) =>
                            'Invalid email and password combination',
                      ),
                    ).show(context);
                  },
                      (_) => ExtendedNavigator.of(context)
                          .replace(Routes.homeScreen)));
        },
        builder: (context, state) => buildScaffold(state, context));
  }

  Scaffold buildScaffold(SignInFormState state, BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(children: <Widget>[
          Image.asset('assets/icon_sign_in.png'),
          Form(
              autovalidate: state.showErrorMessages,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: Container(color: Color(0xff00000000)), flex: 34),
                    buildEmailContainer(context),
                    const SizedBox(height: 16),
                    buildPasswordContainer(context),
                    Expanded(child: SizedBox(), flex: 12),
                    buildSignInExpanded(context),
                    buildRegisterExpanded(context),
                    Expanded(child: SizedBox(), flex: 22)
                  ]))
        ]));
  }

  Expanded buildSignInExpanded(BuildContext context) {
    return Expanded(
        child: GestureDetector(
            child: Container(color: Colors.transparent),
            onTap: () {
              debugPrint('登入');
              context.bloc<SignInFormBloc>().add(
                  const SignInFormEvent.signInWithEmailAndPasswordPressed());
            }),
        flex: 9);
  }

  Expanded buildRegisterExpanded(BuildContext context) {
    return Expanded(
        child: GestureDetector(
            child: Container(color: Colors.transparent),
            onTap: () {
              debugPrint('註冊新會員');
              context.bloc<SignInFormBloc>().add(
                  const SignInFormEvent.registerWithEmailAndPasswordPressed());
            }),
        flex: 13);
  }

  Container buildEmailContainer(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email, color: Color(0xFFFFDB2B)),
                labelText: '會員信箱',
                labelStyle: TextStyle(color: Color(0xFF417D38)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFED742B))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFDB2B)))),
            autocorrect: false,
            onChanged: (value) => context
                .bloc<SignInFormBloc>()
                .add(SignInFormEvent.emailChanged(value)),
            validator: (_) =>
                context.bloc<SignInFormBloc>().state.emailAddress.value.fold(
                      (f) => f.maybeMap(
                        invalidEmail: (_) => '信箱錯誤',
                        orElse: () => null,
                      ),
                      (_) => null,
                    )));
  }

  Container buildPasswordContainer(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock, color: Color(0xFFFFDB2B)),
                labelText: '密碼',
                labelStyle: TextStyle(color: Color(0xFF417D38)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFED742B))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFDB2B)))),
            autocorrect: false,
            obscureText: true,
            onChanged: (value) => context
                .bloc<SignInFormBloc>()
                .add(SignInFormEvent.passwordChanged(value)),
            validator: (_) =>
                context.bloc<SignInFormBloc>().state.password.value.fold(
                      (f) => f.maybeMap(
                        shortPassword: (_) => '密碼錯誤',
                        orElse: () => null,
                      ),
                      (_) => null,
                    )));
  }
}
