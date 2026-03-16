part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileUnauthenticated extends ProfileState {}

final class ProfileAuthenticated extends ProfileState {
  final UserProfile user;

  const ProfileAuthenticated({required this.user});

  ProfileAuthenticated copyWith({UserProfile? user}) {
    return ProfileAuthenticated(user: user ?? this.user);
  }

  @override
  List<Object?> get props => [user];
}

final class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

final class ProfileUpdating extends ProfileState {
  final UserProfile currentUser;

  const ProfileUpdating({required this.currentUser});

  @override
  List<Object?> get props => [currentUser];
}

// User profile data model
class UserProfile extends Equatable {
  final String id;
  final String name;
  final String phoneNumber;
  final String? avatarPath;
  final String email;
  final DateTime joinedDate;

  const UserProfile({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.avatarPath,
    required this.email,
    required this.joinedDate,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? avatarPath,
    String? email,
    DateTime? joinedDate,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarPath: avatarPath ?? this.avatarPath,
      email: email ?? this.email,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    phoneNumber,
    avatarPath,
    email,
    joinedDate,
  ];
}
