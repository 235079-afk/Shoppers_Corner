import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/theme_toggle_button.dart';
import '../../../auth/presentation/widgets/sign_in_button.dart';
import '../../../auth/presentation/widgets/welcome_text.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/cart_summary.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<CartCubit>();
    if (cubit.state is CartInitial) {
      cubit.fetchCart();
    }
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear cart?'),
        content: const Text('This will remove all items from your cart.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<CartCubit>().clearCart();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state is CartLoaded && state.items.isNotEmpty) {
                return IconButton(
                  tooltip: 'Clear cart',
                  icon: const Icon(Icons.delete_sweep_outlined),
                  onPressed: () => _confirmClear(context),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const ThemeToggleButton(),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            return switch (state) {
              CartInitial() || CartLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              CartError(:final message) => _CartErrorView(message: message),
              CartLoaded(items: final items) when items.isEmpty =>
                const _EmptyCartView(),
              CartLoaded() => _CartBody(state: state),
            };
          },
        ),
      ),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

class _CartErrorView extends StatelessWidget {
  final String message;
  const _CartErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.read<CartCubit>().fetchCart(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartBody extends StatelessWidget {
  final CartLoaded state;
  const _CartBody({required this.state});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;
        final crossAxisCount = constraints.maxWidth >= 1100 ? 2 : 1;

        final list = isWide
            ? GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisExtent: 116,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 12,
                ),
                itemCount: state.items.length,
                itemBuilder: (context, index) =>
                    CartItemTile(item: state.items[index]),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: state.items.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    CartItemTile(item: state.items[index]),
              );

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: list),
              SizedBox(
                width: 320,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
                  child: CartSummary(state: state),
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            Expanded(child: list),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: CartSummary(state: state),
            ),
          ],
        );
      },
    );
  }
}
