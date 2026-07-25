import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
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
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthOtpRequired) {
              context.push(
                '${RoutePaths.otp}?email=${Uri.encodeComponent(state.email)}',
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            final errorMessage = state is AuthError ? state.message : null;

            return SingleChildScrollView(
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
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Google sign up clicked')),
                    ),
                  ),
                  const SizedBox(height: 12),

                  SocialLoginButton(
                    icon: Icons.apple,
                    label: 'Sign up with Apple',
                    iconColor: Colors.black,
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Apple sign up clicked')),
                    ),
                  ),
                  const SizedBox(height: 12),

                  SocialLoginButton(
                    icon: Icons.facebook,
                    label: 'Sign up with Facebook',
                    iconColor: Colors.black,
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Facebook sign up clicked')),
                    ),
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

                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        errorMessage,
                        style: TextStyle(
                          color: Colors.red.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                  SignInButton(
                    label: 'Sign Up & Send OTP →',
                    isLoading: isLoading,
                    onPressed: () => context.read<AuthCubit>().signUp(
                          firstName: _firstNameController.text.trim(),
                          lastName: _lastNameController.text.trim(),
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        ),
                  ),

                  const SizedBox(height: 24),

                  AuthSwitchText(
                    isLogin: false,
                    onPressed: () => context.pushReplacement(RoutePaths.login),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
