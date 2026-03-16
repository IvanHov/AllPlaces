import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'bloc/explore_bloc.dart';
import '../../common/widgets/location_item_widget.dart';
import '../../common/widgets/rounded_button_widget.dart';
import 'widgets/section_widget.dart';
import '../../generated/l10n.dart';
import '../../common/widgets/search_bar.dart' as custom;
import '../../common/view_models/collection_view_model.dart';
import '../../common/router/route_name.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ExplorePage();
  }
}

class _ExplorePage extends StatefulWidget {
  const _ExplorePage();

  @override
  State<_ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<_ExplorePage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  final int _selectedTab = 0;

  @override
  bool get wantKeepAlive => false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          RoundedButtonWidget(
            icon: Icons.person_outline,
            onTap: () => context.push(RouteName.profile),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: custom.SearchBar(
              controller: _searchController,
              enabled: false,
              onTap: () => context.push(RouteName.search),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (context, state) {
        if (state is ExploreLoading) {
          return const Center(child: PlatformCircularProgressIndicator());
        } else if (state is ExploreError) {
          return Center(child: Text(S.of(context).error(state.message)));
        } else if (state is ExploreLoaded) {
          return SafeArea(bottom: false, child: _buildContent(state));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildContent(ExploreLoaded state) {
    switch (_selectedTab) {
      case 0:
        return _buildLocationsContent(state);
      case 1:
        return Center(child: Text(S.current.tipsNotImplemented));
      case 2:
        return Center(child: Text(S.current.clubsNotImplemented));
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLocationsContent(ExploreLoaded state) {
    final collectionViewModels = state.viewModels;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = _getCrossAxisCount(width);

        if (crossAxisCount > 1) {
          return _buildGridLayout(collectionViewModels, crossAxisCount);
        } else {
          return _buildMobileLayout(collectionViewModels);
        }
      },
    );
  }

  int _getCrossAxisCount(double width) {
    if (width > 1200) return 4;
    if (width > 768) return 3;
    if (width > 480) return 2;
    return 1;
  }

  Widget _buildGridLayout(
    List<CollectionViewModel> collectionViewModels,
    int crossAxisCount,
  ) {
    return CustomScrollView(
      // Добавляем кэширование для лучшей производительности
      cacheExtent: 1500,
      slivers: [
        SliverToBoxAdapter(child: _buildSearchHeader()),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final collectionViewModel = collectionViewModels[index];
            final isLastSection = index == collectionViewModels.length - 1;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildCollectionSection(
                collectionViewModel,
                crossAxisCount,
                isLast: isLastSection,
              ),
            );
          }, childCount: collectionViewModels.length),
        ),
      ],
    );
  }

  Widget _buildCollectionSection(
    CollectionViewModel collectionViewModel,
    int crossAxisCount, {
    bool isLast = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 64 : 32, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => context.push(
                    RouteName.collection,
                    extra: collectionViewModel,
                  ),
                  child: Text(
                    collectionViewModel.getName(context),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: Text(S.of(context).viewAll),
                ),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: collectionViewModel.locations.length > 8
                ? 8
                : collectionViewModel.locations.length,
            itemBuilder: (context, index) {
              final location = collectionViewModel.locations[index];
              return LocationItemWidget(
                key: ValueKey(location.id),
                location: location,
                onTap: () => context.push(RouteName.location, extra: location),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(List<CollectionViewModel> collectionViewModels) {
    return CustomScrollView(
      // Добавляем кэширование для лучшей производительности
      cacheExtent: 1500,
      slivers: [
        SliverToBoxAdapter(child: _buildSearchHeader()),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final collectionViewModel = collectionViewModels[index];
            final isLastSection = index == collectionViewModels.length - 1;

            // Use locations from view models
            final locations = collectionViewModel.locations;

            return SectionWidget(
              key: ValueKey(collectionViewModel.id),
              locations: locations,
              onLocationTap: (location) =>
                  context.push(RouteName.location, extra: location),
              collectionViewModel: collectionViewModel,
              isLast: isLastSection,
            );
          }, childCount: collectionViewModels.length),
        ),
      ],
    );
  }
}
