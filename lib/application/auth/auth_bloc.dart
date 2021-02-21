import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddd_firebase_demo/domain/auth/i_auth_facade.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';

part 'auth_state.dart';

part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthFacade _authFacade;

  AuthBloc(this._authFacade) : super(const AuthState.initial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    debugPrint('auth_bloc.dart, AuthBloc, mapEventToState, '
        'event: $event');

    yield* event.map(
      authCheckRequested: (e) async* {
        debugPrint('auth_bloc.dart, AuthBloc, mapEventToState, '
            'authCheckRequested');
        final userOption = await _authFacade.getSignedInUser();
        yield userOption.fold(
          () {
            debugPrint('auth_bloc.dart, AuthBloc, mapEventToState, '
                'return const AuthState.unauthenticated()');
            return const AuthState.unauthenticated();
          },
          (_) {
            debugPrint('auth_bloc.dart, AuthBloc, mapEventToState, '
                'return const AuthState.authenticated()');
            return const AuthState.authenticated();
          },
        );
      },
      signedOut: (e) async* {
        debugPrint('auth_bloc.dart, AuthBloc, mapEventToState, '
            'signedOut');
        await _authFacade.signOut();
        yield const AuthState.unauthenticated();
      },
    );
  }
}
