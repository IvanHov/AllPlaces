import 'package:domain/domain.dart';
import '../../modules/profile/bloc/profile_bloc.dart';

/// Maps between Domain User models and UI UserProfile models
class UserMapper {
  /// Converts Domain User to UI UserProfile
  static UserProfile toUserProfile(User user) {
    return UserProfile(
      id: user.id,
      name: user.name ?? 'User', // Fallback if name is null
      phoneNumber: user.phone,
      email: user.email ?? 'user@example.com', // Fallback if email is null
      avatarPath: user.avatarPath,
      joinedDate: user.createdAt,
    );
  }

  /// Converts UI UserProfile to Domain User
  static User toDomainUser(UserProfile profile) {
    return User(
      id: profile.id,
      phone: profile.phoneNumber,
      name: profile.name,
      email: profile.email,
      avatarPath: profile.avatarPath,
      createdAt: profile.joinedDate,
      updatedAt: DateTime.now(),
    );
  }

  /// Creates a mock Domain User from phone number (for new users)
  static User createMockUser({
    required String phoneNumber,
    String? name,
    String? email,
  }) {
    final now = DateTime.now();
    return User(
      id: 'user_${phoneNumber.replaceAll('+', '')}',
      phone: phoneNumber,
      name: name,
      email: email ?? 'user@example.com',
      createdAt: now.subtract(const Duration(days: 30)), // Mock joined date
      updatedAt: now,
    );
  }

  /// Updates Domain User with new data and returns updated UserProfile
  static UserProfile updateUserProfile(
    UserProfile currentProfile, {
    String? name,
    String? phoneNumber,
    String? email,
    String? avatarPath,
  }) {
    return currentProfile.copyWith(
      name: name ?? currentProfile.name,
      phoneNumber: phoneNumber ?? currentProfile.phoneNumber,
      email: email ?? currentProfile.email,
      avatarPath: avatarPath ?? currentProfile.avatarPath,
    );
  }
}
