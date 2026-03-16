import 'package:flutter/material.dart';
import '../../../common/widgets/policy_modal.dart';
import '../../../generated/l10n.dart';
import '../about_app_page.dart';
import 'unified_item.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).info,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
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
              // Support
              // _InfoItem(
              //   icon: Icons.help_outline,
              //   title: S.of(context).support,
              //   onTap: () => _handleSupportTap(context),
              //   isFirst: true,
              // ),
              // const Divider(height: 1, thickness: 0.5),
              // Legal
              SettingItem(
                icon: 'assets/icons/legal.png',
                title: S.of(context).legal,
                onTap: () => _handleLegalTap(context),
              ),
              const Divider(height: 1, thickness: 0.5),
              // About App
              SettingItem(
                icon: 'assets/icons/about.png',
                title: S.of(context).aboutApp,
                onTap: () => _handleAboutAppTap(context),
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // void _handleSupportTap(BuildContext context) {
  //   ScaffoldMessenger.of(
  //     context,
  //   ).showSnackBar(SnackBar(content: Text(S.of(context).tipsNotImplemented)));
  // }

  void _handleLegalTap(BuildContext context) {
    PolicyModal.show(context);
  }

  void _handleAboutAppTap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: const AboutAppPage(),
      ),
    );
  }
}
