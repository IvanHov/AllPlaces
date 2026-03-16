part of 'explore_bloc.dart';

sealed class ExploreState extends Equatable {
  const ExploreState();

  @override
  List<Object?> get props => [];
}

final class ExploreLoading extends ExploreState {}

final class ExploreLoaded extends ExploreState {
  final List<CollectionViewModel> viewModels;

  const ExploreLoaded({required this.viewModels});

  @override
  List<Object?> get props => [viewModels];
}

final class ExploreError extends ExploreState {
  final String message;

  const ExploreError(this.message);

  @override
  List<Object?> get props => [message];
}
