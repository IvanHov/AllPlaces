import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/widgets/phone_auth_widget.dart';
import '../../auth/widgets/otp_auth_widget.dart';
import '../../auth/widgets/name_auth_widget.dart';

class AuthManagerWidget extends StatelessWidget {
  final VoidCallback? onAuthSuccess;

  const AuthManagerWidget({super.key, this.onAuthSuccess});

  static Future<void> showModal(
    BuildContext context, {
    VoidCallback? onAuthSuccess,
  }) async {
    final profileBloc = context.read<ProfileBloc>();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: profileBloc),
          BlocProvider(create: (_) => AuthBloc()..add(const AuthStarted())),
        ],
        child: AuthManagerWidget(onAuthSuccess: onAuthSuccess),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) => prev.step != curr.step,
      listener: (context, state) {
        if (state.step == AuthStep.success) {
          // Handle successful authentication
          final phone = state.phone;
          context.read<ProfileBloc>().add(SignInWithPhone(phone));
          _handleSuccess(context);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              switch (state.step) {
                case AuthStep.phone:
                  return PhoneAuthWidget(onSuccess: () {});
                case AuthStep.otp:
                  return OtpAuthWidget(
                    phoneNumber: state.phone,
                    onSuccess: () {},
                    onBack: () {
                      // Handle back navigation if needed
                    },
                  );
                case AuthStep.name:
                  return NameAuthWidget(onSuccess: () {});
                default:
                  return PhoneAuthWidget(onSuccess: () {});
              }
            },
          ),
        ),
      ),
    );
  }

  void _handleSuccess(BuildContext context) {
    onAuthSuccess?.call();
    // Close the modal when authentication is successful
    Navigator.of(context).pop();
  }
}
