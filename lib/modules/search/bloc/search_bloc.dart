import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final _repository = GetIt.instance<ContentRepository>();

  SearchBloc() : super(SearchInitial()) {
    on<LoadSearch>(_onLoadSearch);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<ClearSearch>(_onClearSearch);
    on<SelectSearchResult>(_onSelectSearchResult);
  }

  Future<void> _onLoadSearch(
    LoadSearch event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    try {
      emit(
        SearchLoaded(
          allLocations: await _repository.getAllLocations(),
          searchResults: [],
          currentQuery: '',
        ),
      );
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) {
    if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      final query = event.query.toLowerCase().trim();

      if (query.isEmpty) {
        emit(
          SearchLoaded(
            allLocations: currentState.allLocations,
            searchResults: [],
            currentQuery: '',
          ),
        );
        return;
      }

      final results = _performSearch(currentState.allLocations, query);

      emit(
        SearchLoaded(
          allLocations: currentState.allLocations,
          searchResults: results,
          currentQuery: query,
        ),
      );
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      emit(
        SearchLoaded(
          allLocations: currentState.allLocations,
          searchResults: [],
          currentQuery: '',
        ),
      );
    }
  }

  void _onSelectSearchResult(
    SelectSearchResult event,
    Emitter<SearchState> emit,
  ) {
    // Handle search result selection if needed
    // This could trigger navigation or other actions
  }

  List<Location> _performSearch(List<Location> locations, String query) {
    final results = <Location>[];

    // Search in locations
    for (final location in locations) {
      if (_matchesLocation(location, query)) {
        results.add(location);
      }
    }

    // Sort results by relevance (prioritize exact matches)
    results.sort((a, b) {
      final aScore = _getRelevanceScore(a, query);
      final bScore = _getRelevanceScore(b, query);
      return bScore.compareTo(aScore);
    });

    return results;
  }

  bool _matchesLocation(Location location, String query) {
    return location.name.en.toLowerCase().contains(query) ||
        location.name.ru.toLowerCase().contains(query) ||
        location.name.uz.toLowerCase().contains(query) ||
        location.type.toJson().toLowerCase().contains(query);
  }
}

int _getRelevanceScore(dynamic item, String query) {
  int score = 0;
  String name = '';

  if (item is Location) {
    name = item.name.en.toLowerCase();
    // Higher score for type matches
    if (item.type.toJson().toLowerCase().contains(query)) {
      score += 10;
    }
  }

  // Higher score for exact name matches
  if (name == query) {
    score += 100;
  } else if (name.startsWith(query)) {
    score += 50;
  } else if (name.contains(query)) {
    score += 25;
  }

  return score;
}
