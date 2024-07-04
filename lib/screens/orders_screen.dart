import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';

import '../widgets/order_list.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('your orders!')),
        drawer: MainDrawer(),
        body:   OrderListView());
  }
}
