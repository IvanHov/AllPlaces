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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:allplaces_client/src/protocol/auth_response.dart' as _i3;
import 'protocol.dart' as _i4;

/// Endpoint for phone/OTP authentication.
///
/// In dev mode (default), OTP is always '0000'.
/// Set the 'smsGatewayEnabled' password to 'true' to enable
/// real OTP generation (SMS sending not yet implemented).
/// {@category Endpoint}
class EndpointAuth extends _i1.EndpointRef {
  EndpointAuth(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'auth';

  /// Sends an OTP to the given phone number.
  /// Returns true if the OTP was sent successfully.
  _i2.Future<bool> sendOtp(String phone) => caller.callServerEndpoint<bool>(
    'auth',
    'sendOtp',
    {'phone': phone},
  );

  /// Verifies the OTP and returns an auth response.
  /// For new users, userName will be null.
  _i2.Future<_i3.AuthResponse> verifyOtp(
    String phone,
    String code,
  ) => caller.callServerEndpoint<_i3.AuthResponse>(
    'auth',
    'verifyOtp',
    {
      'phone': phone,
      'code': code,
    },
  );

  /// Updates the user's display name. Requires a valid session token.
  _i2.Future<_i3.AuthResponse> updateUserName(
    String token,
    String name,
  ) => caller.callServerEndpoint<_i3.AuthResponse>(
    'auth',
    'updateUserName',
    {
      'token': token,
      'name': name,
    },
  );

  /// Signs out by deleting the session.
  _i2.Future<bool> signOut(String token) => caller.callServerEndpoint<bool>(
    'auth',
    'signOut',
    {'token': token},
  );

  /// Validates a session token and returns user info.
  _i2.Future<_i3.AuthResponse> validateSession(String token) =>
      caller.callServerEndpoint<_i3.AuthResponse>(
        'auth',
        'validateSession',
        {'token': token},
      );
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i4.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    auth = EndpointAuth(this);
  }

  late final EndpointAuth auth;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {'auth': auth};

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
