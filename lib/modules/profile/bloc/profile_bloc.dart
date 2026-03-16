import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';
import '../../../common/mappers/user_mapper.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  User? _currentUser;
  final SavingLocationsUseCase _savedLocationsUseCase =
      GetIt.instance<SavingLocationsUseCase>();
  final AuthUseCase _authUseCase = GetIt.instance<AuthUseCase>();
  StreamSubscription<List<String>>? _savedLocationsSubscription;

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<RefreshProfile>(_onRefreshProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<SignInWithPhone>(_onSignInWithPhone);
    on<SignOut>(_onSignOut);
    on<UpdateAvatar>(_onUpdateAvatar);
    on<DeleteAccount>(_onDeleteAccount);
    on<UpdateSavedLocationsCount>(_onUpdateSavedLocationsCount);
    on<UpdateUserName>(_onUpdateUserName);

    // Подписываемся на изменения сохраненных локаций
    _subscribeToSavedLocations();
  }

  @override
  Future<void> close() {
    _savedLocationsSubscription?.cancel();
    return super.close();
  }

  void _subscribeToSavedLocations() {
    _savedLocationsSubscription = _savedLocationsUseCase
        .watchSavedLocationIds()
        .listen((_) {
          // Когда изменяются сохраненные локации, обновляем статистику
          add(UpdateSavedLocationsCount());
        });
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      // Check if user is authenticated
      final hasValidSession = await _authUseCase.hasValidSession();

      if (hasValidSession) {
        final currentSession = await _authUseCase.getCurrentSession();
        final storedUserName = await _authUseCase.getStoredUserName();

        if (currentSession != null) {
          // Create Domain User from session data
          _currentUser = UserMapper.createMockUser(
            phoneNumber: currentSession.providerUid,
            name: storedUserName,
          );

          // Convert to UserProfile for UI
          final userProfile = UserMapper.toUserProfile(_currentUser!);
          emit(ProfileAuthenticated(user: userProfile));
        } else {
          emit(ProfileUnauthenticated());
        }
      } else {
        emit(ProfileUnauthenticated());
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onRefreshProfile(
    RefreshProfile event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileAuthenticated && _currentUser != null) {
      final currentState = state as ProfileAuthenticated;

      emit(ProfileUpdating(currentUser: currentState.user));

      try {
        // Refresh user data - for now just emit the same user
        // In a real app, you might fetch updated data from the server
        final userProfile = UserMapper.toUserProfile(_currentUser!);

        emit(ProfileAuthenticated(user: userProfile));

        // Update current user reference
        _currentUser = _currentUser;
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    } else {
      // If not authenticated, reload the profile from scratch
      add(LoadProfile());
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileAuthenticated && _currentUser != null) {
      final currentState = state as ProfileAuthenticated;

      emit(ProfileUpdating(currentUser: currentState.user));

      try {
        // Update Domain User
        final updatedDomainUser = _currentUser!.copyWith(
          name: event.name,
          phone: event.phoneNumber,
          avatarPath: event.avatarPath,
          updatedAt: DateTime.now(),
        );

        // Convert to UserProfile for UI
        final updatedUserProfile = UserMapper.toUserProfile(updatedDomainUser);

        emit(ProfileAuthenticated(user: updatedUserProfile));

        _currentUser = updatedDomainUser;
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> _onSignInWithPhone(
    SignInWithPhone event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      // Get stored username if available
      final storedUserName = await _authUseCase.getStoredUserName();

      // Create Domain User from phone number
      _currentUser = UserMapper.createMockUser(
        phoneNumber: event.phoneNumber,
        name: storedUserName,
      );

      // Convert to UserProfile for UI
      final userProfile = UserMapper.toUserProfile(_currentUser!);
      emit(ProfileAuthenticated(user: userProfile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onSignOut(SignOut event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try {
      // Sign out using AuthUseCase
      await _authUseCase.signOut();

      // Clear local profile data
      _currentUser = null;

      emit(ProfileUnauthenticated());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateAvatar(
    UpdateAvatar event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileAuthenticated && _currentUser != null) {
      final currentState = state as ProfileAuthenticated;

      emit(ProfileUpdating(currentUser: currentState.user));

      try {
        // Update Domain User
        final updatedDomainUser = _currentUser!.copyWith(
          avatarPath: event.avatarPath,
          updatedAt: DateTime.now(),
        );

        // Convert to UserProfile for UI
        final updatedUserProfile = UserMapper.toUserProfile(updatedDomainUser);

        emit(ProfileAuthenticated(user: updatedUserProfile));

        _currentUser = updatedDomainUser;
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      // Sign out and delete session
      await _authUseCase.signOut();

      // Clear local profile data
      _currentUser = null;

      emit(ProfileUnauthenticated());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateSavedLocationsCount(
    UpdateSavedLocationsCount event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileAuthenticated && _currentUser != null) {
      final currentState = state as ProfileAuthenticated;

      try {
        // For now, just re-emit the same state
        // In a real app, you might update saved locations count in the user model
        emit(ProfileAuthenticated(user: currentState.user));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateUserName(
    UpdateUserName event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileAuthenticated) {
      final currentState = state as ProfileAuthenticated;

      try {
        // Update Domain User with new name
        if (_currentUser != null) {
          final updatedDomainUser = _currentUser!.copyWith(
            name: event.name,
            updatedAt: DateTime.now(),
          );

          // Convert to UserProfile for UI
          final updatedUserProfile = UserMapper.toUserProfile(
            updatedDomainUser,
          );
          emit(ProfileAuthenticated(user: updatedUserProfile));
          _currentUser = updatedDomainUser;
        } else {
          // If no current user, just update the UI with the provided name
          final updatedUser = currentState.user.copyWith(name: event.name);
          emit(ProfileAuthenticated(user: updatedUser));
        }
      } catch (e) {
        emit(ProfileError('Failed to update user name: $e'));
      }
    }
  }
}
