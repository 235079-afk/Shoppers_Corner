class Product {
  final String id;
  final String productCode;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String color;
final double rating;


  const Product({
  required this.id,
  required this.productCode,
  required this.name,
  required this.description,
  required this.imageUrl,
  required this.price,
  this.color = "Unknown",
  this.rating = 0.0,
}
);

}
