import 'dart:convert';

import '../../../../core/constants/local_keys.dart';
import '../../../../core/local_storage/base_local_storage.dart';
import '../models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();

  Future<void> saveCartItems(List<CartItemModel> items);
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final BaseLocalStorage _localStorage;

  CartLocalDataSourceImpl(this._localStorage);

  @override
  Future<List<CartItemModel>> getCartItems() async {
    final raw = await _localStorage.getString(LocalKeys.cartItems);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveCartItems(List<CartItemModel> items) async {
    final encoded = jsonEncode(items.map((e) => e.toJson()).toList());
    await _localStorage.setString(LocalKeys.cartItems, encoded);
  }
}
