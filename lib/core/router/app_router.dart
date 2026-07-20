import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';
import '../../features/products/presentation/cubit/product_cubit.dart';
import '../../features/products/presentation/cubit/product_state.dart';
import '../../features/products/presentation/pages/home_screen.dart';
import '../../features/products/presentation/pages/product_details_screen.dart';
import 'route_paths.dart';

GoRouter buildAppRouter({
  required AuthCubit authCubit,
  required ProductCubit productCubit,
}) {
  return GoRouter(
    initialLocation: RoutePaths.login,
    routes: [
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => BlocProvider<AuthCubit>.value(
          value: authCubit,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: RoutePaths.signup,
        builder: (context, state) => BlocProvider<AuthCubit>.value(
          value: authCubit,
          child: const SignUpScreen(),
        ),
      ),
      GoRoute(
        path: RoutePaths.home,
        builder: (context, state) => BlocProvider<AuthCubit>.value(
          value: authCubit,
          child: BlocProvider<ProductCubit>.value(
            value: productCubit,
            child: const HomeScreen(),
          ),
        ),
      ),
      GoRoute(
        path: RoutePaths.productDetails,
        builder: (context, state) {
          final id = state.uri.queryParameters['id'];
          final productState = productCubit.state;
          final product = productState is ProductLoaded
              ? productState.products.firstWhere((p) => p.id == id)
              : null;
          return ProductDetailsScreen(product: product!);
        },
      ),
    ],
  );
}
