import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/products/data/datasources/product_remote_data_source.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/usecases/get_product_details_usecase.dart';
import '../../features/products/domain/usecases/get_products_usecase.dart';
import '../../features/products/presentation/cubit/product_cubit.dart';
import '../network/api_consumer.dart';
import '../network/dio_client.dart';
import '../network/dio_consumer.dart';
import '../router/app_router.dart';
import '../theme/cubit/theme_cubit.dart';

final getIt = GetIt.instance;

void initDependencies() {
  getIt.registerLazySingleton<Dio>(() => DioClient.create());
  getIt.registerLazySingleton<ApiConsumer>(() => DioConsumer(getIt()));

  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton<SignUpUseCase>(() => SignUpUseCase(getIt()));
  getIt.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(getIt()),
  );

  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(getIt()),
  );
  getIt.registerLazySingleton<GetProductDetailsUseCase>(
    () => GetProductDetailsUseCase(getIt()),
  );

  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  getIt.registerLazySingleton<GoRouter>(() => buildAppRouter());
  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(getIt(), getIt(), getIt()),
  );
  getIt.registerLazySingleton<ProductCubit>(
    () => ProductCubit(getIt(), getIt()),
  );
}
