import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../generated/l10n.dart';
import '../../../common/widgets/main_button_widget.dart';
import '../bloc/profile_bloc.dart';

class SignOutButtonWidget extends StatelessWidget {
  const SignOutButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is! ProfileAuthenticated && state is! ProfileUpdating) {
          return const SizedBox.shrink();
        }

        final isLoading = state is ProfileUpdating;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: MainButtonWidget(
                onPressed: isLoading ? null : () => _signOut(context),
                text: S.of(context).signOut,
                isLoading: isLoading,
                width: double.infinity,
                backgroundColor: Theme.of(context).colorScheme.error,
                icon: const Icon(Icons.logout, size: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  void _signOut(BuildContext context) {
    final profileBloc = context.read<ProfileBloc>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).signOut,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).signOutConfirm,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: MainButtonWidget(
                    onPressed: () {
                      Navigator.of(modalContext).pop();
                      profileBloc.add(SignOut());
                    },
                    text: S.of(context).signOut,
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
