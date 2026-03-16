part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchLoaded extends SearchState {
  final List<Location> allLocations;
  final List<Location> searchResults;
  final String currentQuery;

  const SearchLoaded({
    required this.allLocations,
    required this.searchResults,
    required this.currentQuery,
  });

  @override
  List<Object?> get props => [allLocations, searchResults, currentQuery];
}

final class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}
