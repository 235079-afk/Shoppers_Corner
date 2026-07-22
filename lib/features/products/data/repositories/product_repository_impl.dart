import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Product>>> getProducts() {
    return _remoteDataSource.fetchProducts();
  }

  @override
  Future<Either<Failure, Product>> getProductDetails(String id) {
    return _remoteDataSource.fetchProductById(id);
  }
}
