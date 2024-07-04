import 'package:flutter/material.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final List<CartItem> products;
  final double total;
  final DateTime datetime;
  final String orderId;

  OrderItem({
    required this.products,
    required this.total,
    required this.datetime,
    required this.orderId,
  });
}

class Orders with ChangeNotifier {
  final String token;
  final String userId;
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Orders(this.token, this.userId);

//whatever calc any order is based upon is dependent on the existence of the product items ,
//otherwise it will throw bad state error

  Future<void> fetchAndSetOrders() async {
    _orders = [];
    final uri = Uri.https(
        'shop-app-60819-default-rtdb.europe-west1.firebasedatabase.app',
        '/orders/$userId.json',
        {'auth': token});

    final response = await http.get(uri);


    final parsedBody = json.decode(response.body);
    if (parsedBody == null) {
      return;
    } else {
      parsedBody as Map<dynamic,dynamic>;
    }


    parsedBody.forEach((key, value) {


      _orders.add(OrderItem(
          total: value['total'],
          datetime: DateTime.parse(value['timeStamp']),
          orderId: key,
          products: (value['products'] as List<dynamic>).map((e) {
            return CartItem(
                cartId: DateTime.now().toString(),
                price: e['price'],
                quantity: e['quantity'],
                productId: e['id']);
          }).toList() as List<CartItem>));
    });
    _orders = _orders.reversed.toList();
  }

  Future<void> addOrder(
      List<CartItem> cart, double total, Products products) async {
    final dateTime = DateTime.now();

    try {
      final uri = Uri.https(
          'shop-app-60819-default-rtdb.europe-west1.firebasedatabase.app',
          '/orders/$userId.json',
          {'auth': token});

      final response = await http.post(uri,
          body: json.encode({
            'total': total,
            'timeStamp': dateTime.toIso8601String(),
            'products': cart.map((e) {
              final product = products.items
                  .firstWhere((element) => e.productId == element.id);
              return {
                'quantity': e.quantity,
                'price': e.price,
                'id': product.id,
                'title': product.title
              };
            }).toList()
          }));

      _orders.insert(
          0,
          OrderItem(
              products: cart,
              datetime: dateTime,
              orderId: json.decode(response.body)['name'],
              total: total));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
