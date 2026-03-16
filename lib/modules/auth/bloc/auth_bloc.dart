import 'dart:async';

import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../generated/l10n.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCase _authUseCase;

  AuthBloc({AuthUseCase? authUseCase})
    : _authUseCase = authUseCase ?? GetIt.instance<AuthUseCase>(),
      super(const AuthState.initial()) {
    on<AuthStarted>(_onStarted);
    on<AuthReset>(_onReset);
    on<AuthBackPressed>(_onBack);
    on<AuthPhoneSubmitted>(_onPhoneSubmitted);
    on<AuthOtpSubmitted>(_onOtpSubmitted);
    on<AuthNameSubmitted>(_onNameSubmitted);
    on<AuthCheckSession>(_onCheckSession);
    on<AuthSignOut>(_onSignOut);
  }

  FutureOr<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Check for existing session
      final hasValidSession = await _authUseCase.hasValidSession();
      if (hasValidSession) {
        final currentSession = await _authUseCase.getCurrentSession();
        final storedUserName = await _authUseCase.getStoredUserName();
        emit(
          state.copyWith(
            step: AuthStep.success,
            currentSession: currentSession,
            name: storedUserName,
            isAuthenticated: true,
            isLoading: false,
          ),
        );
      } else {
        emit(const AuthState.initial());
      }
    } catch (e) {
      // If there's an error checking session, start fresh
      emit(const AuthState.initial());
    }
  }

  FutureOr<void> _onReset(AuthReset event, Emitter<AuthState> emit) async {
    emit(const AuthState.initial());
  }

  FutureOr<void> _onBack(AuthBackPressed event, Emitter<AuthState> emit) async {
    switch (state.step) {
      case AuthStep.phone:
        // Let UI close
        break;
      case AuthStep.otp:
        emit(state.copyWith(step: AuthStep.phone, error: null));
        break;
      case AuthStep.name:
        emit(state.copyWith(step: AuthStep.otp, error: null));
        break;
      case AuthStep.success:
      case AuthStep.failure:
        emit(const AuthState.initial());
        break;
    }
  }

  FutureOr<void> _onPhoneSubmitted(
    AuthPhoneSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      await _authUseCase.sendOTP(event.phone);
      emit(
        state.copyWith(
          step: AuthStep.otp,
          phone: event.phone,
          isLoading: false,
          error: null,
        ),
      );
    } on InvalidPhoneNumberException catch (e) {
      emit(state.copyWith(isLoading: false, error: e.message));
    } on NetworkException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: S.current.networkError(e.message),
        ),
      );
    } on ServerException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: S.current.serverError(e.message),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: S.current.failedToSendOtp(e.toString()),
        ),
      );
    }
  }

  FutureOr<void> _onOtpSubmitted(
    AuthOtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, otp: event.code, error: null));

    try {
      // Verify OTP and get session with optional userName
      final (session, userName) = await _authUseCase.verifyOTP(
        state.phone,
        event.code,
      );

      if (userName == null || userName.isEmpty) {
        // New user needs to provide their name
        emit(
          state.copyWith(
            step: AuthStep.name,
            isNewUser: true,
            isLoading: false,
            error: null,
            currentSession: session,
          ),
        );
      } else {
        // Existing user with name, complete authentication
        emit(
          state.copyWith(
            step: AuthStep.success,
            isNewUser: false,
            name: userName,
            isLoading: false,
            currentSession: session,
            isAuthenticated: true,
          ),
        );
      }
    } on InvalidOtpException catch (e) {
      emit(state.copyWith(isLoading: false, error: e.message));
    } on OtpExpiredException catch (e) {
      emit(state.copyWith(isLoading: false, error: e.message));
    } on NetworkException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: S.current.networkError(e.message),
        ),
      );
    } on ServerException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: S.current.serverError(e.message),
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  FutureOr<void> _onNameSubmitted(
    AuthNameSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      // Update user name in the backend
      final session = await _authUseCase.updateUserName(event.name.trim(), phoneNumber: state.phone);

      // Complete authentication for user
      emit(
        state.copyWith(
          step: AuthStep.success,
          name: event.name.trim(),
          isLoading: false,
          currentSession: session,
          isAuthenticated: true,
        ),
      );
    } on InvalidUserNameException catch (e) {
      emit(state.copyWith(isLoading: false, error: e.message));
    } on NetworkException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: S.current.networkError(e.message),
        ),
      );
    } on ServerException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: S.current.serverError(e.message),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: S.current.failedToUpdateName(e.toString()),
        ),
      );
    }
  }

  FutureOr<void> _onCheckSession(
    AuthCheckSession event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final hasValidSession = await _authUseCase.hasValidSession();
      if (hasValidSession) {
        final currentSession = await _authUseCase.getCurrentSession();
        final storedUserName = await _authUseCase.getStoredUserName();
        emit(
          state.copyWith(
            currentSession: currentSession,
            name: storedUserName,
            isAuthenticated: true,
            step: AuthStep.success,
          ),
        );
      } else {
        emit(state.clearSession());
      }
    } catch (e) {
      emit(
        state.clearSession().copyWith(
          error: S.current.sessionCheckFailed(e.toString()),
        ),
      );
    }
  }

  FutureOr<void> _onSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      await _authUseCase.signOut();
      emit(const AuthState.initial());
    } catch (e) {
      // Even if sign out fails, clear local state
      emit(
        state.clearSession().copyWith(
          error: S.current.signOutFailed(e.toString()),
        ),
      );
    }
  }
}
