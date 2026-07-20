import 'package:go_router/go_router.dart';

import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/products/data/datasources/product_remote_data_source.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/usecases/get_products_usecase.dart';
import '../../features/products/presentation/cubit/product_cubit.dart';
import '../network/dio_client.dart';
import '../router/app_router.dart';
import '../theme/cubit/theme_cubit.dart';

class AppDependencies {
  final ThemeCubit themeCubit;
  final AuthCubit authCubit;
  final ProductCubit productCubit;
  final GoRouter router;

  AppDependencies._({
    required this.themeCubit,
    required this.authCubit,
    required this.productCubit,
    required this.router,
  });

  factory AppDependencies.create() {
    final dio = DioClient.create();

    final authRepository = AuthRepositoryImpl();
    final loginUseCase = LoginUseCase(authRepository);
    final signUpUseCase = SignUpUseCase(authRepository);

    final productRemoteDataSource = ProductRemoteDataSource(dio);
    final productRepository = ProductRepositoryImpl(productRemoteDataSource);
    final getProductsUseCase = GetProductsUseCase(productRepository);

    final authCubit = AuthCubit(loginUseCase, signUpUseCase);
    final productCubit = ProductCubit(getProductsUseCase);

    return AppDependencies._(
      themeCubit: ThemeCubit(),
      authCubit: authCubit,
      productCubit: productCubit,
      router: buildAppRouter(authCubit: authCubit, productCubit: productCubit),
    );
  }
}
