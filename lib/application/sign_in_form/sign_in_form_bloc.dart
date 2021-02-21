import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_ddd_firebase_demo/domain/auth/auth_failure.dart';
import 'package:flutter_ddd_firebase_demo/domain/auth/i_auth_facade.dart';
import 'package:flutter_ddd_firebase_demo/domain/auth/value_objects.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

part 'sign_in_form_event.dart';

part 'sign_in_form_state.dart';

part 'sign_in_form_bloc.freezed.dart';

@injectable
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;

  SignInFormBloc(this._authFacade) : super(SignInFormState.initial());

  @override
  Stream<SignInFormState> mapEventToState(
    SignInFormEvent event,
  ) async* {
    debugPrint('sign_in_form_bloc.dart, SignInFormBloc, mapEventToState, '
        'event: $event');

    yield* event.map(
      emailChanged: (e) async* {
        debugPrint('sign_in_form_bloc.dart, SignInFormBloc, mapEventToState, '
            'emailChanged, emailStr: ${e.emailStr}');
        yield state.copyWith(
          emailAddress: EmailAddress(e.emailStr),
          authFailureOrSuccessOption: none(),
        );
      },
      passwordChanged: (e) async* {
        debugPrint('sign_in_form_bloc.dart, SignInFormBloc, mapEventToState, '
            'passwordChanged, passwordStr: ${e.passwordStr}');
        yield state.copyWith(
          password: Password(e.passwordStr),
          authFailureOrSuccessOption: none(),
        );
      },
      registerWithEmailAndPasswordPressed: (e) async* {
        debugPrint('sign_in_form_bloc.dart, SignInFormBloc, mapEventToState, '
            'registerWithEmailAndPasswordPressed');
        yield* _performActionOnAuthFacadeWithEmailAndPassword(
          _authFacade.registerWithEmailAndPassword,
        );
      },
      signInWithEmailAndPasswordPressed: (e) async* {
        debugPrint('sign_in_form_bloc.dart, SignInFormBloc, mapEventToState, '
            'signInWithEmailAndPasswordPressed');
        yield* _performActionOnAuthFacadeWithEmailAndPassword(
          _authFacade.signInWithEmailAndPassword,
        );
      },
      signInWithGooglePressed: (e) async* {
        debugPrint('sign_in_form_bloc.dart, SignInFormBloc, mapEventToState, '
            'signInWithGooglePressed');
        yield state.copyWith(
          isSubmitting: true,
          authFailureOrSuccessOption: none(),
        );
        final failureOrSuccess = await _authFacade.signInWithGoogle();
        yield state.copyWith(
          isSubmitting: false,
          authFailureOrSuccessOption: some(failureOrSuccess),
        );
      },
    );
  }

  Stream<SignInFormState> _performActionOnAuthFacadeWithEmailAndPassword(
    Future<Either<AuthFailure, Unit>> Function({
      @required EmailAddress emailAddress,
      @required Password password,
    })
        forwardedCall,
  ) async* {
    debugPrint('sign_in_form_bloc.dart, SignInFormBloc, '
        '_performActionOnAuthFacadeWithEmailAndPassword');

    Either<AuthFailure, Unit> failureOrSuccess;

    final isEmailValid = state.emailAddress.isValid();
    debugPrint('sign_in_form_bloc.dart, SignInFormBloc, '
        '_performActionOnAuthFacadeWithEmailAndPassword, '
        'isEmailValid: $isEmailValid');
    final isPasswordValid = state.password.isValid();
    debugPrint('sign_in_form_bloc.dart, SignInFormBloc, '
        '_performActionOnAuthFacadeWithEmailAndPassword, '
        'isPasswordValid: $isPasswordValid');

    if (isEmailValid && isPasswordValid) {
      yield state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: none(),
      );

      failureOrSuccess = await forwardedCall(
        emailAddress: state.emailAddress,
        password: state.password,
      );
    }

    yield state.copyWith(
      isSubmitting: false,
      showErrorMessages: true,
      authFailureOrSuccessOption: optionOf(failureOrSuccess),
    );
  }
}
