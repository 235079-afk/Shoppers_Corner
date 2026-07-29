import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>.value(value: getIt<ThemeCubit>()),
        BlocProvider<CartCubit>.value(value: getIt<CartCubit>()..fetchCart()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Shoppers Corner',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            routerConfig: getIt<GoRouter>(),
          );
        },
      ),
    );
  }
}
