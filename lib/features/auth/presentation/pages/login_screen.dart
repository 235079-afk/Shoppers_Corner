import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/theme_toggle_button.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/social_login_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/sign_in_button.dart';
import '../widgets/or_divider.dart';
import '../widgets/auth_switch_text.dart';
import '../widgets/forgot_password_link.dart';
import '../widgets/welcome_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [ThemeToggleButton(), SizedBox(width: 8)],
      ),
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              context.go(RoutePaths.home);
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),

                SvgPicture.asset(
                  'assets/images/shopping_bag_outline_icon.svg',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onSurface,
                    BlendMode.srcIn,
                  ),
                ),

                const SizedBox(height: 8),

                const WelcomeText(text: 'Welcome Back, Shopper'),

                const SizedBox(height: 40),

                SocialLoginButton(
                  icon: Icons.g_mobiledata,
                  label: 'Login with Google',
                  iconColor: Colors.black,
                  onPressed: () => _handleSocialLogin('Google'),
                ),
                const SizedBox(height: 12),
                SocialLoginButton(
                  icon: Icons.apple,
                  label: 'Login with Apple',
                  iconColor: Colors.black,
                  onPressed: () => _handleSocialLogin('Apple'),
                ),
                const SizedBox(height: 12),
                SocialLoginButton(
                  icon: Icons.facebook,
                  label: 'Login with Facebook',
                  iconColor: Colors.black,
                  onPressed: () => _handleSocialLogin('Facebook'),
                ),

                const SizedBox(height: 24),
                const OrDivider(),
                const SizedBox(height: 24),

                CustomTextField(
                  controller: _userController,
                  label: 'Username',
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: _obscurePassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),

                const SizedBox(height: 12),

                ForgotPasswordLink(onPressed: _handleForgotPassword),

                const SizedBox(height: 24),

                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = switch (state) {
                      AuthLoading() => true,
                      AuthInitial() || AuthSuccess() || AuthError() => false,
                    };

                    return SignInButton(
                      label: 'Sign In →',
                      isLoading: isLoading,
                      onPressed: _handleSignIn,
                    );
                  },
                ),

                const SizedBox(height: 24),

                AuthSwitchText(
                  isLogin: true,
                  onPressed: () => context.go(RoutePaths.signup),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSocialLogin(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$provider login clicked')),
    );
  }

  void _handleForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Forgot password clicked')),
    );
  }

  void _handleSignIn() {
    context.read<AuthCubit>().login(
          _userController.text.trim(),
          _passwordController.text.trim(),
        );
  }
}
