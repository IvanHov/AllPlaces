import 'dart:convert';

import 'package:allplaces_client/allplaces_client.dart';
import 'package:domain/exceptions/auth_exceptions.dart';
import 'package:domain/interfaces/auth_repository.dart';
import 'package:domain/models/session.dart' as domain;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Serverpod implementation of [AuthRepository].
/// Communicates with the AllPlaces Serverpod server
/// for phone/OTP authentication.
class ServerpodAuthRepositoryImpl implements AuthRepository {
  static const String _sessionKey = 'user_session';
  static const String _userNameKey = 'user_name';
  static const String _tokenKey = 'server_token';
  static const String _userPhoneKey = 'user_phone';

  final Client _client;
  final FlutterSecureStorage _secureStorage;

  ServerpodAuthRepositoryImpl({
    required Client client,
    FlutterSecureStorage? secureStorage,
  })  : _client = client,
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  @override
  Future<bool> sendOTP(String phone) async {
    try {
      return await _client.auth.sendOtp(phone);
    } on ServerpodClientException catch (e) {
      throw ServerException(
        'Server error: ${e.message}',
        statusCode: e.statusCode,
      );
    } catch (e) {
      throw NetworkException('Network error while sending OTP: $e');
    }
  }

  @override
  Future<(domain.Session? session, String? userName)> verifyOTP(
    String phone,
    String otp,
  ) async {
    try {
      final response = await _client.auth.verifyOtp(phone, otp);

      if (!response.success) {
        final error = response.error ?? '';
        if (error.toLowerCase().contains('expired')) {
          throw const OtpExpiredException();
        } else if (error.toLowerCase().contains('invalid')) {
          throw const InvalidOtpException();
        } else {
          throw ServerException(error);
        }
      }

      final token = response.token!;
      await _secureStorage.write(key: _tokenKey, value: token);

      if (response.userName == null || response.userName!.isEmpty) {
        // New user — wait for name input
        return (null, null);
      }

      // Existing user — create session
      final session = _createSession(
        response.userId!,
        phone,
        token,
      );
      await saveSession(session);
      await _secureStorage.write(
        key: _userNameKey,
        value: response.userName,
      );

      return (session, response.userName);
    } on AuthException {
      rethrow;
    } on ServerpodClientException catch (e) {
      throw ServerException(
        'Server error: ${e.message}',
        statusCode: e.statusCode,
      );
    } catch (e) {
      throw NetworkException('Network error while verifying OTP: $e');
    }
  }

  @override
  Future<domain.Session?> updateUserName(
    String name, {
    String? phoneNumber,
  }) async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);
      if (token == null) {
        throw const InvalidSessionException();
      }

      final response = await _client.auth.updateUserName(token, name);

      if (!response.success) {
        throw ServerException(response.error ?? 'Failed to update name');
      }

      await _secureStorage.write(key: _userNameKey, value: name);

      final session = _createSession(
        response.userId!,
        phoneNumber ?? '',
        token,
      );
      await saveSession(session);

      return session;
    } on AuthException {
      rethrow;
    } on ServerpodClientException catch (e) {
      throw ServerException(
        'Server error: ${e.message}',
        statusCode: e.statusCode,
      );
    } catch (e) {
      throw NetworkException('Network error while updating name: $e');
    }
  }

  @override
  Future<void> saveSession(domain.Session session) async {
    final sessionJson = jsonEncode(session.toJson());
    await _secureStorage.write(key: _sessionKey, value: sessionJson);
    if (session.providerUid.isNotEmpty) {
      await _secureStorage.write(
        key: _userPhoneKey,
        value: session.providerUid,
      );
    }
  }

  @override
  Future<domain.Session?> getCurrentSession() async {
    try {
      final sessionJson = await _secureStorage.read(key: _sessionKey);
      if (sessionJson == null) return null;

      final sessionData =
          jsonDecode(sessionJson) as Map<String, dynamic>;
      return domain.Session.fromJson(sessionData);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteSession() async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);
      if (token != null) {
        try {
          await _client.auth.signOut(token);
        } catch (_) {
          // Best effort — still clear local storage
        }
      }
    } finally {
      await _secureStorage.delete(key: _sessionKey);
      await _secureStorage.delete(key: _userNameKey);
      await _secureStorage.delete(key: _tokenKey);
      await _secureStorage.delete(key: _userPhoneKey);
    }
  }

  @override
  Future<bool> hasValidSession() async {
    final session = await getCurrentSession();
    if (session == null) return false;
    if (session.isExpired) {
      await deleteSession();
      return false;
    }
    return true;
  }

  @override
  Future<String?> getStoredUserName() async {
    try {
      return await _secureStorage.read(key: _userNameKey);
    } catch (e) {
      return null;
    }
  }

  domain.Session _createSession(int userId, String phone, String token) {
    final now = DateTime.now();
    return domain.Session(
      id: token,
      userId: 'user-$userId',
      createdAt: now,
      expiresAt: now.add(const Duration(days: 30)),
      provider: 'serverpod',
      providerUid: phone,
      current: true,
    );
  }
}
