import 'package:flutter/material.dart';
import '../widgets/cart_list_grid.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('your cart'),
      ),
      body: CartListView(),
    );
  }
}
