import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/theme_toggle_button.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../auth/presentation/widgets/or_divider.dart';
import '../../../auth/presentation/widgets/sign_in_button.dart';
import '../../../auth/presentation/widgets/welcome_text.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final name = authState is AuthSuccess ? authState.user : 'there';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: const [ThemeToggleButton(), SizedBox(width: 8)],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              WelcomeText(text: 'Hi, $name'),
              const SizedBox(height: 32),
              const OrDivider(),
              const SizedBox(height: 32),
              SignInButton(
                label: 'Log Out',
                onPressed: () {
                  context.read<AuthCubit>().logout();
                  context.go(RoutePaths.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
