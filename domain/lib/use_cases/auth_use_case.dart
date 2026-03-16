import '../interfaces/auth_repository.dart';
import '../models/session.dart';
import '../exceptions/auth_exceptions.dart';

class AuthUseCase {
  final AuthRepository _authRepository;

  AuthUseCase(this._authRepository);

  Future<void> sendOTP(String phoneInput) async {
    try {
      // Simple phone validation
      if (phoneInput.isEmpty) {
        throw const InvalidPhoneNumberException('Phone number cannot be empty');
      }

      // Remove all non-digit characters for validation
      final digits = phoneInput.replaceAll(RegExp(r'\D'), '');

      // Check if starts with 998 and has 12 digits total
      if (!(digits.startsWith('998') && digits.length == 12)) {
        throw const InvalidPhoneNumberException(
          'Phone number must start with +998 and contain 9 additional digits',
        );
      }

      // Normalize phone number format
      final normalizedPhone = '+$digits';

      await _authRepository.sendOTP(normalizedPhone);
    } on InvalidPhoneNumberException {
      rethrow; // Re-throw domain validation exceptions
    } catch (e) {
      throw NetworkException('Failed to send OTP: $e');
    }
  }

  Future<(Session?, String?)> verifyOTP(
    String phoneInput,
    String otpInput,
  ) async {
    try {
      // Simple phone validation
      if (phoneInput.isEmpty) {
        throw const InvalidPhoneNumberException('Phone number cannot be empty');
      }

      // Simple OTP validation
      if (otpInput.isEmpty) {
        throw const InvalidOtpException('OTP code cannot be empty');
      }

      // Remove any non-digit characters from OTP
      final digits = otpInput.replaceAll(RegExp(r'\D'), '');

      if (digits.length != 4) {
        throw const InvalidOtpException('OTP code must be exactly 4 digits');
      }

      // Normalize phone number
      final phoneDigits = phoneInput.replaceAll(RegExp(r'\D'), '');
      final normalizedPhone = '+$phoneDigits';

      final (session, userName) = await _authRepository.verifyOTP(
        normalizedPhone,
        digits,
      );
      return (session, userName);
    } on InvalidPhoneNumberException {
      rethrow;
    } on InvalidOtpException {
      rethrow;
    } catch (e) {
      // Convert generic exceptions to domain-specific ones
      if (e.toString().contains('expired')) {
        throw const OtpExpiredException();
      } else if (e.toString().contains('invalid') ||
          e.toString().contains('wrong')) {
        throw const InvalidOtpException('Invalid OTP code');
      } else {
        throw NetworkException('Failed to verify OTP: $e');
      }
    }
  }

  Future<Session?> updateUserName(String nameInput, {String? phoneNumber}) async {
    try {
      // Simple name validation
      final trimmed = nameInput.trim();

      if (trimmed.isEmpty) {
        throw const InvalidUserNameException('Name cannot be empty');
      }

      if (trimmed.length < 2) {
        throw const InvalidUserNameException(
          'Name must be at least 2 characters long',
        );
      }

      if (trimmed.length > 50) {
        throw const InvalidUserNameException(
          'Name cannot exceed 50 characters',
        );
      }

      // Check for invalid characters (allow Unicode letters, spaces, hyphens, apostrophes)
      if (!RegExp(r"^[\p{L}\s\-']+$", unicode: true).hasMatch(trimmed)) {
        throw const InvalidUserNameException(
          'Name can only contain letters, spaces, hyphens, and apostrophes',
        );
      }

      await _authRepository.updateUserName(trimmed, phoneNumber: phoneNumber);
      return await _authRepository.getCurrentSession();
    } on InvalidUserNameException {
      rethrow; // Re-throw domain validation exceptions
    } catch (e) {
      throw NetworkException('Failed to update user name: $e');
    }
  }

  // Session methods
  Future<Session?> getCurrentSession() async {
    try {
      return await _authRepository.getCurrentSession();
    } catch (e) {
      throw NetworkException('Failed to get current session: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.deleteSession();
    } catch (e) {
      throw NetworkException('Failed to sign out: $e');
    }
  }

  // Utility methods
  Future<bool> isSignedIn() async {
    try {
      final session = await getCurrentSession();
      return session != null && !session.isExpired;
    } catch (e) {
      return false; // If there's an error, assume not signed in
    }
  }

  Future<bool> hasValidSession() async {
    try {
      return await _authRepository.hasValidSession();
    } catch (e) {
      return false; // If there's an error, assume no valid session
    }
  }

  Future<String?> getStoredUserName() async {
    try {
      return await _authRepository.getStoredUserName();
    } catch (e) {
      return null; // If there's an error, return null
    }
  }
}
