import 'package:flutter/material.dart';
import '../providers/product.dart';

class CartItem {
  final String cartId;
  final String productId;
  final int quantity;
  final double price;

  const CartItem(
      {required this.cartId,
      required this.productId,
      required this.quantity,
      required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  Cart updateItems(List<Product> products) {
    bool contains = false;
    final keys = [];
    _items.forEach((key, value) {
      for (var element in products) {
        if (element.id == key) {
          contains = true;
          _items[key] = CartItem(
              cartId: value.cartId,
              productId: value.productId,
              price: element.price,
              quantity: value.quantity);
        }
      }
      if (contains == false) {
        keys.add(key);
      }
      contains = false;
    });

    for (var key in keys) {
      _items.remove(key);
    }

    notifyListeners();
    return this;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  int get itemsCount {
    int count = 0;
    _items.forEach((key, value) {
      count += value.quantity;
    });

    return count;
  }

  double get totalAmount {
    double total = 0;
    items.forEach((key, value) {
      total += value.price * value.quantity;
    });

    return total;
  }

  void addCartItem(String productId, double productPrice) {
    if (_items.containsKey(productId)) {
      _items.update(productId, (existingItem) {
        return CartItem(
            price: existingItem.price,
            cartId: existingItem.cartId,
            productId: productId,
            quantity: existingItem.quantity + 1);
      });
    } else {
      _items.putIfAbsent(productId, () {
        return CartItem(
            price: productPrice,
            productId: productId,
            quantity: 1,
            cartId: DateTime.now().toString());
      });
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void removeSingleItemFromCart(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    final CartItem cartItem = _items.values.firstWhere((cartItem) {
      return cartItem.productId == productId;
    });
    if (cartItem.quantity > 1) {
      _items.update(productId, (previousCartItem) {
        return CartItem(
            cartId: previousCartItem.cartId,
            productId: productId,
            price: previousCartItem.price,
            quantity: previousCartItem.quantity - 1);
      });
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}



//using list as an option 

// var cItem= _items.firstWhere((cartItem) {

//   return cartItem.productId == productId;
// });

// var itemIndex = _items.indexWhere((element) {  return element.productId == productId;});

// if(cartIndex >= 0){
// _items.replaceRange(cartIndex, cartIndex , CartItem(productId: productId,quantity: ));

// }