import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/sign_up_usecase.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth_state.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/pages/signup_screen.dart';
import 'features/products/data/datasources/product_remote_data_source.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/domain/usecases/get_products_usecase.dart';
import 'features/products/presentation/cubit/product_cubit.dart';
import 'features/products/presentation/pages/home_screen.dart';

void main() {
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepositoryImpl();
    final loginUseCase = LoginUseCase(authRepository);
    final signUpUseCase = SignUpUseCase(authRepository);

    final productRemoteDataSource = ProductRemoteDataSource(Dio());
    final productRepository = ProductRepositoryImpl(productRemoteDataSource);
    final getProductsUseCase = GetProductsUseCase(productRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => AuthCubit(loginUseCase, signUpUseCase)),
        BlocProvider(create: (_) => ProductCubit(getProductsUseCase)),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            navigatorKey.currentState?.pushReplacementNamed('/home');
          } else if (state is AuthInitial) {
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              '/login',
              (route) => false,
            );
          }
        },
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              navigatorKey: navigatorKey,
              title: 'Shoppers Corner',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                brightness: Brightness.light,
                scaffoldBackgroundColor: Colors.white,
                primarySwatch: Colors.blue,
                fontFamily: 'Roboto',
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: Colors.black,
                primarySwatch: Colors.blue,
                fontFamily: 'Roboto',
              ),
              themeMode: themeMode,
              initialRoute: '/login',
              routes: {
                '/login': (context) => const LoginScreen(),
                '/signup': (context) => const SignUpScreen(),
                '/home': (context) => const HomeScreen(),
              },
            );
          },
        ),
      ),
    );
  }
}
