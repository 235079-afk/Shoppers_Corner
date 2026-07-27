import 'package:flutter_app/core/constants/local_keys.dart';
import 'package:flutter_app/core/local_storage/base_local_storage.dart';
import 'package:flutter_app/features/splashscreen/splashscreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/otp_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';
import '../../features/cart/presentation/pages/cart_screen.dart';
import '../../features/categories/presentation/cubit/category_cubit.dart';
import '../../features/products/presentation/cubit/product_cubit.dart';
import '../../features/products/presentation/pages/home_screen.dart';
import '../../features/products/presentation/pages/product_details_screen.dart';
import '../../features/products/domain/usecases/get_product_details_usecase.dart';
import '../../features/products/domain/usecases/get_products_usecase.dart';
import '../../features/settings/presentation/pages/settings_screen.dart';
import '../di/injection_container.dart';
import '../widgets/main_shell.dart';
import 'route_paths.dart';
import 'package:flutter_app/features/onboarding/onboardingscreen.dart';

GoRouter buildAppRouter() {
  final BaseLocalStorage localStorage = getIt<BaseLocalStorage>();
  return GoRouter(
    initialLocation: RoutePaths.splash,
    routes: [
      GoRoute( 
        
        path: RoutePaths.splash,
        name: RoutePaths.splash, 
        builder:(context, state) {return SplashScreen();},
        ),
      GoRoute( 
        //the isopen thingy. comment if you want to change the onboarding ui
        redirect: (context, state) async{
          final isOpen = await localStorage.getBool(LocalKeys.isOpen);
          if (isOpen ?? false){
            context.go(RoutePaths.home);
          }
          return;
        },
        //end comment here
        path: RoutePaths.onboarding,
        name: RoutePaths.onboarding , 
        builder:(context, state) {return OnboardingScreen();},
        ),

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
        path: RoutePaths.otp,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return BlocProvider<AuthCubit>.value(
            value: getIt<AuthCubit>(),
            child: OtpScreen(email: email),
          );
        },
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
                    BlocProvider<CategoryCubit>.value(
                      value: getIt<CategoryCubit>(),
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
        name: RoutePaths.productDetailsName,
        builder: (context, state) {
          final id = state.uri.queryParameters['id'] ?? '';
          return BlocProvider<ProductCubit>(
            create: (_) => ProductCubit(
              getIt<GetProductsUseCase>(),
              getIt<GetProductDetailsUseCase>(),
            ),
            child: ProductDetailsScreen(productId: id),
          );
        },
      ),
    ],
  );
}
