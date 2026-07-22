import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/theme_toggle_button.dart';
import '../../../auth/presentation/widgets/sign_in_button.dart';
import '../../../auth/presentation/widgets/welcome_text.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: const [ThemeToggleButton(), SizedBox(width: 8)],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 80,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              const WelcomeText(text: 'Your cart is empty'),
              const SizedBox(height: 32),
              SignInButton(
                label: 'Start Shopping →',
                onPressed: () => context.go(RoutePaths.home),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
