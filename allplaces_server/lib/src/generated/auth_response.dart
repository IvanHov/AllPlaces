/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Response returned from OTP verification.
abstract class AuthResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  AuthResponse._({
    required this.success,
    this.token,
    this.userId,
    this.userName,
    this.error,
  });

  factory AuthResponse({
    required bool success,
    String? token,
    int? userId,
    String? userName,
    String? error,
  }) = _AuthResponseImpl;

  factory AuthResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthResponse(
      success: _i1.BoolJsonExtension.fromJson(jsonSerialization['success']),
      token: jsonSerialization['token'] as String?,
      userId: jsonSerialization['userId'] as int?,
      userName: jsonSerialization['userName'] as String?,
      error: jsonSerialization['error'] as String?,
    );
  }

  /// Whether the operation was successful.
  bool success;

  /// Session token for authenticated requests.
  String? token;

  /// User ID.
  int? userId;

  /// User name, null if new user.
  String? userName;

  /// Error message if failed.
  String? error;

  /// Returns a shallow copy of this [AuthResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthResponse copyWith({
    bool? success,
    String? token,
    int? userId,
    String? userName,
    String? error,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuthResponse',
      'success': success,
      if (token != null) 'token': token,
      if (userId != null) 'userId': userId,
      if (userName != null) 'userName': userName,
      if (error != null) 'error': error,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AuthResponse',
      'success': success,
      if (token != null) 'token': token,
      if (userId != null) 'userId': userId,
      if (userName != null) 'userName': userName,
      if (error != null) 'error': error,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthResponseImpl extends AuthResponse {
  _AuthResponseImpl({
    required bool success,
    String? token,
    int? userId,
    String? userName,
    String? error,
  }) : super._(
         success: success,
         token: token,
         userId: userId,
         userName: userName,
         error: error,
       );

  /// Returns a shallow copy of this [AuthResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthResponse copyWith({
    bool? success,
    Object? token = _Undefined,
    Object? userId = _Undefined,
    Object? userName = _Undefined,
    Object? error = _Undefined,
  }) {
    return AuthResponse(
      success: success ?? this.success,
      token: token is String? ? token : this.token,
      userId: userId is int? ? userId : this.userId,
      userName: userName is String? ? userName : this.userName,
      error: error is String? ? error : this.error,
    );
  }
}
