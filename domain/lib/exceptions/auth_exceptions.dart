/// Base class for all authentication-related exceptions
abstract class AuthException implements Exception {
  final String message;
  final String? code;

  const AuthException(this.message, {this.code});

  @override
  String toString() =>
      'AuthException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Exception thrown when phone number is invalid
class InvalidPhoneNumberException extends AuthException {
  const InvalidPhoneNumberException([String? message])
    : super(message ?? 'Invalid phone number format', code: 'INVALID_PHONE');
}

/// Exception thrown when OTP is invalid
class InvalidOtpException extends AuthException {
  const InvalidOtpException([String? message])
    : super(message ?? 'Invalid OTP code', code: 'INVALID_OTP');
}

/// Exception thrown when OTP has expired
class OtpExpiredException extends AuthException {
  const OtpExpiredException([String? message])
    : super(message ?? 'OTP code has expired', code: 'OTP_EXPIRED');
}

/// Exception thrown when user name is invalid
class InvalidUserNameException extends AuthException {
  const InvalidUserNameException([String? message])
    : super(message ?? 'Invalid user name', code: 'INVALID_NAME');
}

/// Exception thrown when session is invalid or expired
class InvalidSessionException extends AuthException {
  const InvalidSessionException([String? message])
    : super(message ?? 'Invalid or expired session', code: 'INVALID_SESSION');
}

/// Exception thrown when user is not found
class UserNotFoundException extends AuthException {
  const UserNotFoundException([String? message])
    : super(message ?? 'User not found', code: 'USER_NOT_FOUND');
}

/// Exception thrown when network operations fail
class NetworkException extends AuthException {
  const NetworkException([String? message])
    : super(message ?? 'Network error occurred', code: 'NETWORK_ERROR');
}

/// Exception thrown when server returns an error
class ServerException extends AuthException {
  final int? statusCode;

  const ServerException(super.message, {this.statusCode, super.code});

  @override
  String toString() =>
      'ServerException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}${code != null ? ' (Code: $code)' : ''}';
}

/// Exception thrown when validation fails
class ValidationException extends AuthException {
  final Map<String, String>? fieldErrors;

  const ValidationException(
    super.message, {
    this.fieldErrors,
    super.code = 'VALIDATION_ERROR',
  });

  @override
  String toString() =>
      'ValidationException: $message${fieldErrors != null ? ' - Fields: ${fieldErrors!.keys.join(', ')}' : ''}';
}
