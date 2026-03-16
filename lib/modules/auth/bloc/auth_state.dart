part of 'auth_bloc.dart';

enum AuthStep { phone, otp, name, success, failure }

const _errorSentinel = Object();

class AuthState extends Equatable {
  final AuthStep step;
  final String phone;
  final String? otp;
  final String? name;
  final bool isNewUser;
  final bool isLoading;
  final String? error;
  final Session? currentSession;
  final bool isAuthenticated;

  const AuthState({
    required this.step,
    required this.phone,
    required this.otp,
    required this.name,
    required this.isNewUser,
    required this.isLoading,
    required this.error,
    required this.currentSession,
    required this.isAuthenticated,
  });

  const AuthState.initial()
    : step = AuthStep.phone,
      phone = '',
      otp = null,
      name = null,
      isNewUser = false,
      isLoading = false,
      error = null,
      currentSession = null,
      isAuthenticated = false;

  AuthState copyWith({
    AuthStep? step,
    String? phone,
    String? otp,
    String? name,
    bool? isNewUser,
    bool? isLoading,
    Object? error = _errorSentinel,
    Session? currentSession,
    bool? isAuthenticated,
  }) {
    return AuthState(
      step: step ?? this.step,
      phone: phone ?? this.phone,
      otp: otp ?? this.otp,
      name: name ?? this.name,
      isNewUser: isNewUser ?? this.isNewUser,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _errorSentinel) ? this.error : error as String?,
      currentSession: currentSession ?? this.currentSession,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  AuthState clearSession() {
    return const AuthState(
      step: AuthStep.phone,
      phone: '',
      otp: null,
      name: null,
      isNewUser: false,
      isLoading: false,
      error: null,
      currentSession: null,
      isAuthenticated: false,
    );
  }

  @override
  List<Object?> get props => [
    step,
    phone,
    otp,
    name,
    isNewUser,
    isLoading,
    error,
    currentSession,
    isAuthenticated,
  ];
}
