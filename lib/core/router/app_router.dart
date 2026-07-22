import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';
import '../../features/products/presentation/cubit/product_cubit.dart';
import '../../features/products/presentation/cubit/product_details_cubit.dart';
import '../../features/products/presentation/pages/home_screen.dart';
import '../../features/products/presentation/pages/product_details_screen.dart';
import '../di/injection_container.dart';
import 'route_paths.dart';

GoRouter buildAppRouter() {
  return GoRouter(
    initialLocation: RoutePaths.login,
    routes: [
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => BlocProvider<AuthCubit>.value(
          value: getIt<AuthCubit>(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: RoutePaths.signup,
        builder: (context, state) => BlocProvider<AuthCubit>.value(
          value: getIt<AuthCubit>(),
          child: const SignUpScreen(),
        ),
      ),
      GoRoute(
        path: RoutePaths.home,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>.value(value: getIt<AuthCubit>()),
            BlocProvider<ProductCubit>.value(value: getIt<ProductCubit>()),
          ],
          child: const HomeScreen(),
        ),
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
    ],
  );
}
