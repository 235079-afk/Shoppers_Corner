
import 'package:flutter_app/features/auth/presentation/pages/otp_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';
import '../../features/cart/presentation/pages/cart_screen.dart';
import '../../features/products/presentation/cubit/product_cubit.dart';
import '../../features/products/presentation/cubit/product_details_cubit.dart';
import '../../features/products/presentation/pages/home_screen.dart';
import '../../features/products/presentation/pages/product_details_screen.dart';
import '../../features/settings/presentation/pages/settings_screen.dart';
import '../di/injection_container.dart';
import '../widgets/auth_shell.dart';
import '../widgets/main_shell.dart';
import 'route_paths.dart';

GoRouter buildAppRouter() {
  return GoRouter(
    initialLocation: RoutePaths.login,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AuthShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.login,
                builder: (context, state) => BlocProvider<AuthCubit>.value(
                  value: getIt<AuthCubit>(),
                  child: const LoginScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.signup,
                builder: (context, state) => BlocProvider<AuthCubit>.value(
                  value: getIt<AuthCubit>(),
                  child: const SignUpScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider<AuthCubit>.value(value: getIt<AuthCubit>()),
                    BlocProvider<ProductCubit>.value(
                      value: getIt<ProductCubit>(),
                    ),
                  ],
                  child: const HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.cart,
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.settings,
                builder: (context, state) => BlocProvider<AuthCubit>.value(
                  value: getIt<AuthCubit>(),
                  child: const SettingsScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.productDetails,
        builder: (context, state) {
          final id = state.uri.queryParameters['id'] ?? '';
          return BlocProvider<ProductDetailsCubit>(
            create: (_) => getIt<ProductDetailsCubit>(),
            child: ProductDetailsScreen(productId: id),
          );
        },
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return OtpScreen(email: email);
        },
      ),
    ],
  );
}
