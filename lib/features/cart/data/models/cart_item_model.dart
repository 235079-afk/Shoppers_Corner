import '../../../products/data/models/product_model.dart';
import '../../domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({required super.product, super.quantity});

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(
        json['product'] as Map<String, dynamic>? ?? const {},
      ),
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': {
        'id': product.id,
        'productCode': product.productCode,
        'name': product.name,
        'description': product.description,
        'coverPictureUrl': product.imageUrl,
        'price': product.price,
        'color': product.color,
        'rating': product.rating,
      },
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromEntity(CartItem item) {
    return CartItemModel(product: item.product, quantity: item.quantity);
  }
}
