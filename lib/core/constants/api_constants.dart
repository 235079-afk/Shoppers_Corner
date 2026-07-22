class ApiConstants {
  static const String productsUrl = 'https://accessories-eshop.runasp.net/api/products';

  static String productDetailsUrl(String id) => '$productsUrl/$id';
}
