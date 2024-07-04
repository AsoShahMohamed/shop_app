import 'package:flutter/material.dart';
import '../screens/orders_screen.dart';
import '../screens/product_overview.dart';
import '../screens/edit_products_screen.dart';
import 'package:provider/provider.dart';
import '../providers/authentication.dart';
import '../helpers/custom_route.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(builder: (_, BoxConstraints constraint) {
        return Drawer(
          width: constraint.maxWidth * 2 / 3,
          child: Column(children: [
            AppBar(
                title: const Text('Navigate through the App!'),
                automaticallyImplyLeading: false),
            const Divider(),
            ListTile(
                leading: const Icon(Icons.shop),
                title: const Text('Products'),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(ProductOverview.routeName);
                }),
            const Divider(),
            ListTile(
                leading: const Icon(Icons.payment),
                title: const Text('orders'),
                onTap: () {
                  // Navigator.of(context)
                  //     .pushReplacementNamed(OrdersScreen.routeName);
                  Navigator.of(context).pushReplacement(CustomRoute(
                      builder: (_cntx) {
                        return OrdersScreen();
                      },
                      settings:
                          RouteSettings(name: '/orders', arguments: 'abc')));
                }),
            const Divider(),
            ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit products'),
                onTap: () {
                  // Navigator.of(context)
                  //     .pushReplacementNamed(EditableProducts.routeName);
                  Navigator.of(context).pushReplacement(CustomRoute(
                      builder: (_) {
                        return EditableProducts();
                      },
                      settings: RouteSettings(name: '/edit-products')));
                }),
            const Divider(),
            ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('logout'),
                onTap: () {
                  //not needed but helps with clearing out more memory space??!

                  Navigator.of(context).pop();
//  Navigator.of(context).pushReplacementNamed('/');
//i dont understand the use of it

                  Provider.of<Authentication>(context, listen: false).logout();
                })
          ]),
        );
      }),
    );
  }
}
