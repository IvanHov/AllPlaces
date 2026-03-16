import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../common/router/route_name.dart';
import 'bloc/auth_bloc.dart';
import 'widgets/phone_auth_widget.dart';
import 'widgets/otp_auth_widget.dart';
import 'widgets/name_auth_widget.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc()..add(const AuthStarted()),
      child: const _AuthPageBody(),
    );
  }
}

class _AuthPageBody extends StatelessWidget {
  const _AuthPageBody();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) =>
          prev.isAuthenticated != curr.isAuthenticated,
      listener: (context, state) {
        if (state.isAuthenticated) {
          context.go(RouteName.home);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state.isLoading &&
                      state.step == AuthStep.phone &&
                      state.phone.isEmpty) {
                    return const CircularProgressIndicator();
                  }

                  switch (state.step) {
                    case AuthStep.phone:
                      return PhoneAuthWidget(
                        onSuccess: () {},
                      );
                    case AuthStep.otp:
                      return OtpAuthWidget(
                        phoneNumber: state.phone,
                        onSuccess: () {},
                        onBack: () {
                          context
                              .read<AuthBloc>()
                              .add(const AuthBackPressed());
                        },
                      );
                    case AuthStep.name:
                      return NameAuthWidget(
                        onSuccess: () {},
                      );
                    case AuthStep.success:
                    case AuthStep.failure:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
