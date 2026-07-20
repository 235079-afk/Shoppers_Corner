import 'product_model.dart';

class ProductsResponseModel {
  final List<ProductModel> items;
  final int? totalCount;
  final int? pageIndex;
  final int? pageSize;

  const ProductsResponseModel({
    required this.items,
    this.totalCount,
    this.pageIndex,
    this.pageSize,
  });

  factory ProductsResponseModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? const [];

    return ProductsResponseModel(
      items: itemsJson
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalCount: json['totalCount'] as int?,
      pageIndex: json['pageIndex'] as int?,
      pageSize: json['pageSize'] as int?,
    );
  }
}
