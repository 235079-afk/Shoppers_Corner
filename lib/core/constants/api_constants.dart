class ApiConstants {
  static const String productsUrl = 'https://accessories-eshop.runasp.net/api/products';
  static const String categoriesUrl = 'https://accessories-eshop.runasp.net/api/categories';

  static String productDetailsUrl(String id) => '$productsUrl/$id';
}
