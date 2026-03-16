import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Endpoint for phone/OTP authentication.
///
/// In dev mode (default), OTP is always '0000'.
/// Set the 'smsGatewayEnabled' password to 'true' to enable
/// real OTP generation (SMS sending not yet implemented).
class AuthEndpoint extends Endpoint {
  static const _otpLength = 4;
  static const _otpExpiry = Duration(minutes: 5);
  static const _sessionExpiry = Duration(days: 30);
  static const _devOtp = '0000';

  /// Sends an OTP to the given phone number.
  /// Returns true if the OTP was sent successfully.
  Future<bool> sendOtp(Session session, String phone) async {
    final devMode = !_isSmsEnabled(session);

    final code = devMode ? _devOtp : _generateOtp();
    final now = DateTime.now();

    // Store OTP in database
    await OtpCode.db.insertRow(
      session,
      OtpCode(
        phone: phone,
        code: code,
        expiresAt: now.add(_otpExpiry),
        createdAt: now,
      ),
    );

    if (!devMode) {
      // TODO: Send SMS via gateway
      session.log('OTP for $phone: $code');
    }

    return true;
  }

  /// Verifies the OTP and returns an auth response.
  /// For new users, userName will be null.
  Future<AuthResponse> verifyOtp(
    Session session,
    String phone,
    String code,
  ) async {
    // Find the latest OTP for this phone
    final otpRows = await OtpCode.db.find(
      session,
      where: (t) => t.phone.equals(phone),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: 1,
    );

    if (otpRows.isEmpty) {
      return AuthResponse(
        success: false,
        error: 'No OTP found for this phone number',
      );
    }

    final otp = otpRows.first;

    if (DateTime.now().isAfter(otp.expiresAt)) {
      return AuthResponse(success: false, error: 'OTP expired');
    }

    if (otp.code != code) {
      return AuthResponse(success: false, error: 'Invalid OTP');
    }

    // OTP is valid — clean up used codes
    await OtpCode.db.deleteWhere(
      session,
      where: (t) => t.phone.equals(phone),
    );

    // Find or create user
    final existingUsers = await AppUser.db.find(
      session,
      where: (t) => t.phone.equals(phone),
      limit: 1,
    );

    final now = DateTime.now();
    AppUser user;

    if (existingUsers.isNotEmpty) {
      user = existingUsers.first;
    } else {
      user = await AppUser.db.insertRow(
        session,
        AppUser(
          phone: phone,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    // Create session
    final token = _generateToken();
    await UserSession.db.insertRow(
      session,
      UserSession(
        userId: user.id!,
        token: token,
        expiresAt: now.add(_sessionExpiry),
        createdAt: now,
      ),
    );

    return AuthResponse(
      success: true,
      token: token,
      userId: user.id,
      userName: user.name,
    );
  }

  /// Updates the user's display name. Requires a valid session token.
  Future<AuthResponse> updateUserName(
    Session session,
    String token,
    String name,
  ) async {
    final userSession = await _validateToken(session, token);
    if (userSession == null) {
      return AuthResponse(success: false, error: 'Invalid session');
    }

    final user = await AppUser.db.findById(session, userSession.userId);
    if (user == null) {
      return AuthResponse(success: false, error: 'User not found');
    }

    user.name = name;
    user.updatedAt = DateTime.now();
    await AppUser.db.updateRow(session, user);

    return AuthResponse(
      success: true,
      token: token,
      userId: user.id,
      userName: name,
    );
  }

  /// Signs out by deleting the session.
  Future<bool> signOut(Session session, String token) async {
    final deleted = await UserSession.db.deleteWhere(
      session,
      where: (t) => t.token.equals(token),
    );
    return deleted.isNotEmpty;
  }

  /// Validates a session token and returns user info.
  Future<AuthResponse> validateSession(
    Session session,
    String token,
  ) async {
    final userSession = await _validateToken(session, token);
    if (userSession == null) {
      return AuthResponse(success: false, error: 'Invalid or expired session');
    }

    final user = await AppUser.db.findById(session, userSession.userId);
    if (user == null) {
      return AuthResponse(success: false, error: 'User not found');
    }

    return AuthResponse(
      success: true,
      token: token,
      userId: user.id,
      userName: user.name,
    );
  }

  // -- Private helpers --

  Future<UserSession?> _validateToken(
    Session session,
    String token,
  ) async {
    final sessions = await UserSession.db.find(
      session,
      where: (t) => t.token.equals(token),
      limit: 1,
    );

    if (sessions.isEmpty) return null;

    final userSession = sessions.first;
    if (DateTime.now().isAfter(userSession.expiresAt)) {
      await UserSession.db.deleteRow(session, userSession);
      return null;
    }

    return userSession;
  }

  bool _isSmsEnabled(Session session) {
    try {
      final value = session.passwords['smsGatewayEnabled'];
      return value == 'true';
    } catch (_) {
      return false;
    }
  }

  String _generateOtp() {
    final random = Random.secure();
    return List.generate(_otpLength, (_) => random.nextInt(10)).join();
  }

  String _generateToken() {
    final random = Random.secure();
    final bytes = List.generate(32, (_) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}
