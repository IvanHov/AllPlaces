import 'package:domain/models/session.dart';

abstract interface class AuthRepository {
  Future<bool> sendOTP(String phone);
  Future<(Session? session, String? userName)> verifyOTP(
    String phone,
    String code,
  );
  Future<Session?> updateUserName(String name, {String? phoneNumber});

  // Session management methods
  Future<void> saveSession(Session session);
  Future<Session?> getCurrentSession();
  Future<void> deleteSession();
  Future<bool> hasValidSession();
  Future<String?> getStoredUserName();
}
