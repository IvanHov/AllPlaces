import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../../../generated/l10n.dart';
import 'unified_item.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is SettingsError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 32,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 8),
                Text(
                  'Error loading settings',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (state is SettingsLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).settings,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Theme Setting
                    // _SettingItem(
                    //   icon: Icons.palette_outlined,
                    //   title: S.of(context).theme,
                    //   subtitle: state.themeMode.displayName,
                    //   onTap: () => _showThemeDialog(context, state.themeMode),
                    //   isFirst: true,
                    // ),
                    // const Divider(height: 1, thickness: 0.5),
                    // Language Setting
                    SettingItem(
                      icon: 'assets/icons/localization.png',
                      title: S.of(context).language,
                      value: state.language.nativeName,
                      onTap: () => _showLanguageDialog(context, state.language),
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  // void _showThemeDialog(BuildContext context, ThemeMode currentTheme) {
  //   showDialog(
  //     context: context,
  //     builder: (dialogContext) => AlertDialog(
  //       title: Text(S.of(context).chooseTheme),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: ThemeMode.values
  //             .map(
  //               (theme) => ListTile(
  //                 leading: Icon(
  //                   theme == currentTheme
  //                       ? Icons.radio_button_checked
  //                       : Icons.radio_button_unchecked,
  //                 ),
  //                 title: Text(theme.displayName),
  //                 subtitle: Text(theme.description),
  //                 onTap: () {
  //                   context.read<SettingsBloc>().add(ChangeTheme(theme));
  //                   Navigator.of(dialogContext).pop();
  //                 },
  //               ),
  //             )
  //             .toList(),
  //       ),
  //     ),
  //   );
  // }

  void _showLanguageDialog(BuildContext context, AppLanguage currentLanguage) {
    showModalBottomSheet(
      context: context,
      builder: (dialogContext) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                S.of(context).chooseLanguage,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...AppLanguage.values.map(
              (language) => ListTile(
                leading: Icon(
                  language == currentLanguage
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                ),
                title: Text(language.nativeName),
                subtitle: Text(language.displayName),
                onTap: () {
                  context.read<SettingsBloc>().add(ChangeLanguage(language));
                  Navigator.of(dialogContext).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
