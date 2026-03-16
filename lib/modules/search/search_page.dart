import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:domain/domain.dart';
import 'package:go_router/go_router.dart';
import '../../common/widgets/back_button_widget.dart';
import '../../generated/l10n.dart';
import '../../common/router/route_name.dart';
import 'bloc/bloc.dart';
import 'widgets/search_result_item.dart';
import 'widgets/no_results_widget.dart';
import '../../common/widgets/search_bar.dart' as custom;

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc()..add(LoadSearch()),
      child: const SearchView(),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late TextEditingController _searchController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
    });
    context.read<SearchBloc>().add(SearchQueryChanged(query));
  }

  void _onClearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
    });
    context.read<SearchBloc>().add(ClearSearch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Center(
                      child: PlatformCircularProgressIndicator(),
                    );
                  } else if (state is SearchError) {
                    return Center(
                      child: Text(S.of(context).error(state.message)),
                    );
                  } else if (state is SearchLoaded) {
                    return _buildContent(context, state);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          const BackButtonWidget(),
          const SizedBox(width: 12),
          Expanded(
            child: custom.SearchBar(
              controller: _searchController,
              autoFocus: true,
              onChanged: _onSearchChanged,
              onClear: _onClearSearch,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, SearchLoaded state) {
    if (!_isSearching || state.currentQuery.isEmpty) {
      return _buildEmptyState(context);
    }

    if (state.searchResults.isEmpty) {
      return NoResultsWidget(
        query: state.currentQuery,
        onSubmitRequest: () {
          // Handle submit request
        },
      );
    }

    return _buildSearchResults(context, state.searchResults);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            S.of(context).findPlacesPrograms,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).searchSubtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, List<Location> results) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: results.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 16, thickness: 1, color: Colors.transparent),
      itemBuilder: (context, index) {
        final item = results[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GestureDetector(
            onTap: () => context.pushNamed(RouteName.location, extra: item),
            child: SearchResultItem(item: item),
          ),
        );
      },
    );
  }
}
