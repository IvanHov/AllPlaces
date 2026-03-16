part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

final class LoadProfile extends ProfileEvent {}

final class RefreshProfile extends ProfileEvent {}

final class UpdateProfile extends ProfileEvent {
  final String name;
  final String phoneNumber;
  final String? avatarPath;

  const UpdateProfile({
    required this.name,
    required this.phoneNumber,
    this.avatarPath,
  });

  @override
  List<Object?> get props => [name, phoneNumber, avatarPath];
}

final class SignIn extends ProfileEvent {}

final class SignInWithPhone extends ProfileEvent {
  final String phoneNumber;

  const SignInWithPhone(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

final class SignOut extends ProfileEvent {}

final class UpdateAvatar extends ProfileEvent {
  final String avatarPath;

  const UpdateAvatar(this.avatarPath);

  @override
  List<Object?> get props => [avatarPath];
}

final class DeleteAccount extends ProfileEvent {}

final class UpdateSavedLocationsCount extends ProfileEvent {}

final class UpdateUserName extends ProfileEvent {
  final String name;

  const UpdateUserName(this.name);

  @override
  List<Object?> get props => [name];
}
