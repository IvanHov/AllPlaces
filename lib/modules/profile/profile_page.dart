import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../generated/l10n.dart';
import 'bloc/profile_bloc.dart';
import 'bloc/settings_bloc.dart';
import 'widgets/login_widget.dart';
import 'widgets/settings_widget.dart';
import 'widgets/info_widget.dart';
import 'widgets/signout_button_widget.dart';
import '../saved_locations/widgets/saved_locations_section.dart';
import '../location/location_page.dart';
import 'package:domain/domain.dart';
import '../../common/widgets/back_button_widget.dart';
import '../../common/widgets/main_button_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProfileBloc()..add(LoadProfile())),
        BlocProvider(create: (context) => SettingsBloc()..add(LoadSettings())),
      ],
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).tabProfile),
        leading: const BackButtonWidget()
      ),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SavedLocationsSection(
                onLocationTap: (Location location) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LocationPage(location: location),
                    ),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32.0)),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SettingsWidget(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32.0)),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: InfoWidget(),
              ),
            ),
            // Sign Out Section
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SignOutButtonWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App Bar Section
        Container(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 12.0, 12.0),
          child: Row(
            children: [
              const BackButtonWidget(),
              const Spacer(),
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileAuthenticated ||
                      state is ProfileUpdating) {
                    final user = state is ProfileAuthenticated
                        ? state.user
                        : (state as ProfileUpdating).currentUser;
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            user.name,
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            user.phoneNumber,
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withValues(alpha: 0.5),
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  }

                  // Default: show "Profile" text
                  return Text(
                    S.of(context).tabProfile,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      S.of(context).errorLoadingProfile,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    MainButtonWidget(
                      text: S.of(context).retry,
                      onPressed: () {
                        context.read<ProfileBloc>().add(LoadProfile());
                      },
                    ),
                  ],
                ),
              );
            }

            if (state is ProfileAuthenticated || state is ProfileUpdating) {
              // User is authenticated, no additional content needed
              return const SizedBox.shrink();
            }

            // ProfileUnauthenticated - show login prompt
            return const LoginWidget();
          },
        ),
      ],
    );
  }
}
