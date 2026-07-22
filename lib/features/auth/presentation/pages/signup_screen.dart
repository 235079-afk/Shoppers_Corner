import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/theme_toggle_button.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/social_login_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/sign_in_button.dart';
import '../widgets/or_divider.dart';
import '../widgets/auth_switch_text.dart';
import '../widgets/welcome_text.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  bool _obscurePassword = true;

  String? _statusMessage; 

  Future<bool> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final url = Uri.parse(
      "https://accessories-eshop.runasp.net/api/auth/register",
    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "confirmPassword": password,
        "firstName": firstName,
        "lastName": lastName,
      }),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    return response.statusCode == 200;
  }

  Future<void> handleSignUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    final success = await registerUser(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );

    if (!mounted) return;

    if (success) {
      setState(() {
        _statusMessage = "OTP sent to your email.";
      });

      context.go('/otp?email=${Uri.encodeComponent(email)}');
    } else {
      setState(() {
        _statusMessage = "Registration failed.";
      });
    }
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
              setState(() {
                _statusMessage = state.message;
              });
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
                const WelcomeText(text: 'Create your account'),
                const SizedBox(height: 40),

                SocialLoginButton(
                  icon: Icons.g_mobiledata,
                  label: 'Sign up with Google',
                  iconColor: Colors.black,
                  onPressed: () => _handleSocialSignUp('Google'),
                ),
                const SizedBox(height: 12),

                SocialLoginButton(
                  icon: Icons.apple,
                  label: 'Sign up with Apple',
                  iconColor: Colors.black,
                  onPressed: () => _handleSocialSignUp('Apple'),
                ),
                const SizedBox(height: 12),

                SocialLoginButton(
                  icon: Icons.facebook,
                  label: 'Sign up with Facebook',
                  iconColor: Colors.black,
                  onPressed: () => _handleSocialSignUp('Facebook'),
                ),

                const SizedBox(height: 24),
                const OrDivider(),
                const SizedBox(height: 24),

                CustomTextField(
                  controller: _firstNameController,
                  label: 'First Name',
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: _lastNameController,
                  label: 'Last Name',
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
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

                const SizedBox(height: 24),

                if (_statusMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      _statusMessage!,
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = switch (state) {
                      AuthLoading() => true,
                      AuthInitial() || AuthSuccess() || AuthError() => false,
                    };

                    return SignInButton(
                      label: 'Sign Up & Send OTP →',
                      isLoading: isLoading,
                      onPressed: handleSignUp,
                    );
                  },
                ),

                const SizedBox(height: 24),

                AuthSwitchText(
                  isLogin: false,
                  onPressed: () => context.go(RoutePaths.login),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSocialSignUp(String provider) {
    setState(() {
      _statusMessage = "$provider sign up clicked";
    });
  }
}
