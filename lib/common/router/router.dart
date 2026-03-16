import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'route_name.dart';
import '../../modules/auth/auth_page.dart';
import '../../modules/explore/explore_page.dart';
import '../../modules/location/location_page.dart';
import '../../modules/profile/profile_page.dart';
import '../../modules/search/search_page.dart';
import '../../modules/collection/collection_page.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../view_models/collection_view_model.dart';

final GoRouter router = GoRouter(
  initialLocation: RouteName.auth,
  redirect: (context, state) async {
    final authUseCase = GetIt.instance<AuthUseCase>();
    final isAuthenticated = await authUseCase.hasValidSession();
    final isAuthRoute =
        state.matchedLocation == RouteName.auth;

    if (!isAuthenticated && !isAuthRoute) {
      return RouteName.auth;
    }

    if (isAuthenticated && isAuthRoute) {
      return RouteName.home;
    }

    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: RouteName.auth,
      name: RouteName.auth,
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: RouteName.home,
      name: RouteName.home,
      builder: (context, state) =>
          const AppBottomNavigationBar(),
    ),
    GoRoute(
      path: RouteName.explore,
      name: RouteName.explore,
      builder: (context, state) => const ExplorePage(),
    ),
    GoRoute(
      path: RouteName.location,
      name: RouteName.location,
      builder: (context, state) {
        final location = state.extra as Location;
        return LocationPage(location: location);
      },
    ),
    GoRoute(
      path: RouteName.collection,
      name: RouteName.collection,
      builder: (context, state) {
        final collectionViewModel =
            state.extra as CollectionViewModel;
        return CollectionPage(
          collectionViewModel: collectionViewModel,
        );
      },
    ),
    GoRoute(
      path: RouteName.profile,
      name: RouteName.profile,
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: RouteName.search,
      name: RouteName.search,
      builder: (context, state) => const SearchPage(),
    ),
  ],
);
