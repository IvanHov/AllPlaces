import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../generated/l10n.dart';
import 'bloc/settings_bloc.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc()..add(LoadSettings()),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return Column(
                children: [
                  // Drag indicator
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          // App Logo and Header Section
                          _buildAppHeader(context),
                          const SizedBox(height: 40),

                          // App Information Section
                          _buildAppInfoSection(
                            context,
                            state is SettingsLoaded ? state.appVersion : null,
                          ),
                          const SizedBox(height: 32),

                          // Features Section
                          _buildFeaturesSection(context),
                          const SizedBox(height: 32),

                          // Copyright Section
                          _buildCopyrightSection(context),
                          const SizedBox(height: 40), // Extra spacing at bottom
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAppHeader(BuildContext context) {
    return const Image(
      image: AssetImage('assets/icons/logo_large.png')
    );
  }

  Widget _buildAppInfoSection(BuildContext context, AppVersion? appVersion) {
    return _buildSection(
      context,
      title: S.of(context).appInformation,
      children: [
        _buildInfoRow(
          context,
          icon: Icons.info_outline,
          title: S.of(context).version,
          value: appVersion?.version ?? 'N/A',
        ),
        _buildInfoRow(
          context,
          icon: Icons.build_outlined,
          title: 'Build',
          value: appVersion?.buildNumber ?? 'N/A',
        ),
        _buildInfoRow(
          context,
          icon: Icons.code_outlined,
          title: 'Code Name',
          value: appVersion?.codeName ?? 'N/A',
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    return _buildSection(
      context,
      title: S.of(context).features,
      children: [
        _buildFeatureRow(
          context,
          icon: Icons.explore_outlined,
          title: S.of(context).exploreLocations,
          description: S.of(context).exploreDescription,
        ),
        _buildFeatureRow(
          context,
          icon: Icons.bookmark_outline,
          title: S.of(context).savedLocations,
          description: S.of(context).savedDescription,
        ),
        _buildFeatureRow(
          context,
          icon: Icons.route_outlined,
          title: S.of(context).tracksGPS,
          description: S.of(context).tracksDescription,
        ),
        _buildFeatureRow(
          context,
          icon: Icons.photo_library_outlined,
          title: S.of(context).gallery,
          description: S.of(context).galleryDescription,
        ),
      ],
    );
  }

  Widget _buildCopyrightSection(BuildContext context) {
    return Column(
      children: [
        Text(
          S.of(context).madeWithLove,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
