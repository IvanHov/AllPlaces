part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {
  const AuthStarted();
}

class AuthPhoneSubmitted extends AuthEvent {
  final String phone;
  const AuthPhoneSubmitted(this.phone);

  @override
  List<Object?> get props => [phone];
}

class AuthOtpSubmitted extends AuthEvent {
  final String code;
  const AuthOtpSubmitted(this.code);

  @override
  List<Object?> get props => [code];
}

class AuthNameSubmitted extends AuthEvent {
  final String name;
  const AuthNameSubmitted(this.name);

  @override
  List<Object?> get props => [name];
}

class AuthBackPressed extends AuthEvent {
  const AuthBackPressed();
}

class AuthReset extends AuthEvent {
  const AuthReset();
}

class AuthCheckSession extends AuthEvent {
  const AuthCheckSession();
}

class AuthSignOut extends AuthEvent {
  const AuthSignOut();
}
