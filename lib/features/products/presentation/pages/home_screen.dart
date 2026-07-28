import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/theme_toggle_button.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../categories/presentation/cubit/category_cubit.dart';
import '../../../categories/presentation/cubit/category_state.dart';
import '../../../categories/presentation/widgets/category_chip.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchProducts();
    context.read<CategoryCubit>().fetchCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final name = authState is AuthSuccess ? authState.user : 'there';
    //final firstName = name.split(' ').first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          const ThemeToggleButton(),
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
              context.go(RoutePaths.login);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<ProductCubit>().fetchProducts();
          await context.read<CategoryCubit>().fetchCategories();
        },
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Hello 👋',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "Here's what's new in the shop.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search categories...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const BannerCarousel(),
            const SizedBox(height: 24),
            const Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 96,
              child: BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  return switch (state) {
                    CategoryInitial() || CategoryLoading() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    CategoryError(:final message) => Center(
                        child: Text(
                          message,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    CategoryLoaded(:final categories) => _CategoryList(
                        categories: categories,
                        query: _searchQuery,
                      ),
                  };
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Best Sellers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                return switch (state) {
                  ProductInitial() || ProductLoading() => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ProductError(:final message) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              message,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () =>
                                  context.read<ProductCubit>().fetchProducts(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ProductLoaded(:final products) => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.take(5).length,
                      itemBuilder: (context, index) =>
                          ProductCard(product: products[index]),
                    ),
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  final List<Category> categories;
  final String query;

  const _CategoryList({required this.categories, required this.query});

  @override
  Widget build(BuildContext context) {
    final filtered = query.isEmpty
        ? categories
        : categories
            .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

    if (filtered.isEmpty) {
      return const Center(child: Text('No categories found'));
    }

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: filtered.length,
      separatorBuilder: (context, index) => const SizedBox(width: 12),
      itemBuilder: (context, index) => CategoryChip(category: filtered[index]),
    );
  }
}
